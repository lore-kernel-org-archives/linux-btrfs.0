From: Steven Pratt <slpratt@austin.ibm.com>
Subject: New perf results
Date: Mon, 16 Nov 2009 16:26:28 -0600
Message-ID: <4B01D194.9040605@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

New performance results have been uploaded for recent runs, including 
the nodatasum option and a refresh of other file systems on current kernel.

http://btrfs.boxacle.net/repository/raid/history/History.html

No big surprises here, with the possible exception of the impact of 
csums.  For example 128 thread sequential read  increased from about 
380MB/sec to 630MB/sec by skipping checksums.  This happened even though 
we were only using about 40% cpu in the normal case.  So, even though we 
are not CPU bound, the overhead of checksums introduces some major 
performance penalties. 

Chris, are most of your runs on Nehelam based systems?  I know we had 
some different results on some tests and wonder if this is one of the 
causes.  Not sure when/if I can move up to a newer system.

Also some updates to the single disk system as well, although I am 
lagging getting all the runs in on that box.

http://btrfs.boxacle.net/repository/single-disk/History/History.html

Steve
