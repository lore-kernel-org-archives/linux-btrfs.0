From: Steven Pratt <steve@dangyankee.net>
Subject: Updated performance results
Date: Thu, 23 Jul 2009 13:35:21 -0500
Message-ID: <4A68AD69.4030803@dangyankee.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have re-run the raid tests with re-creating the fileset between each 
of the random write workloads and performance does now match the 
previous newformat results.  The bad news is that the huge gain that I 
had attributed to the newformat release, does not really exist.  All of 
the previous results(except for the newformat run) were not re-creating 
the fileset, so the gain in performance was due only to having a fresh 
set of files, not any code changes.

So, I have done 2 new sets of runs to look into this further. One is a 3 
hour run of single threaded random write to the RAID system.  I have 
compared this to ext3.  Performance results are here:  
http://btrfs.boxacle.net/repository/raid/longwrite/longwrite/Longrandomwrite.html

and graphing of all the iostat data can be found here:

http://btrfs.boxacle.net/repository/raid/longwrite/summary.html

The iostat graphs for btrfs are interesting for a number of reasons.  
First, it takes about 3000 seconds (or 50 minutes) for btrfs to reach 
steady state.  Second, if you look at write throughput from the device 
view vs. the btrfs/application view, we see that for a application 
throughput of 21.5MB/sec it requires 63MB/sec of actual disk writes.  
That is an overhead of 3 to 1 vs an overhead of ~0 for ext3. Also, 
looking at the change in iops vs MB/sec, we see that while  btrfs starts 
out with reasonable size IOs, it quickly deteriorate to an average IO 
size of only 13kb.  Remember, the starting file set is only 100GB on a 
2.1TB filesystem, and all data is overwrite, and this is single 
threaded, so there is no reason this should fragment.  It seems like the 
allocator is having a problem doing sequential allocations.

Another set of runs I did was to do repetitive 5 minute random write 
runs.  Results are here:
http://btrfs.boxacle.net/repository/raid/repeat/repeat/repeat.html

This shows the dramatic degredation after just a short time, but I 
believe there is a fair amount of overhead in btrfs after newly mounting 
the FS (which this test did between each run) so I repeated without 
unmounting and remounting and results are here:
http://btrfs.boxacle.net/repository/raid/repeat-nomount/repeat/repeat-nomount.html

These results show a much less dramatic degradation, but btrfs still 
degrades by over 40% in just 30 minutes of run time.  In fact, it was 
still degrading by 10% every 5 minutes when this test ended.

Steve
