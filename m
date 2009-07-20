From: Steven Pratt <slpratt@austin.ibm.com>
Subject: Random write regression
Date: Mon, 20 Jul 2009 08:11:42 -0500
Message-ID: <4A646D0E.1060006@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Finally got around to going through latest data.  Seems like we lost all 
the random write performance gains.  Creates are better, but total 
regression on the random workload.  Sequential reads seem to have 
dropped as well.

Results are uploading now.  
http://btrfs.boxacle.net/repository/raid/history/History.html

These are for RAID only as single disk system still having issues 
completing btrfs runs.  Also, missing oprofile duw to oprofile causing 
an NMI and killing the system.

Chris, this was built on 7/6, but I see no new changes sine 7/2/. 

Steve


