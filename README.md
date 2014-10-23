feedupdater
===========

Project to fetch manga

Roadmap:

Figure out an algorithm to pull from multiple sources.

Different sites have different href values for 'next'. 
  -- either consolidate a list for the supported sites or
  -- figure out a regex that'll find the href next

Another Approach: get the total number of pages in a given chapter.
craft the urls with iterating numbers up to the final count.
This approach may be the best. (works universally instead of relying on href magic regex or hardcoded list)

Different sites have different names for chapters
  -- figure out if chapters have a ~like~ similarity, don't save.

Enable multi-threading to increase performance.
  -- If website A has 3 updates and website B and C also have the same 3 updates,
           multi-thread to pull 1 update from each at the same time.

  -- But if website A has 4 updates and website B and C only have 2 of the same. 
           (Meaning, website A updates faster)
           
  -- lets multi-thread on B and C but single-thread on A for 2 pulls.

