From: Steven Pratt <slpratt@austin.ibm.com>
Subject: More performance results
Date: Tue, 16 Dec 2008 09:44:25 -0600
Message-ID: <4947CCD9.3040304@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Just realized that I never posted the link to the results from a few 
weeks ago.  These are from the November 20 git tree, just before the 
move to the 2.6.28-rc based kernels.  We have been having some issues 
with the new kernel (unrelated to btrfs) that have kept us from getting 
newer results.  Will post as soon as we have them.

http://btrfs.boxacle.net/repository/raid/history/History.html

For these results I show a history of the last 3 btrfs runs so we can 
see how performance is changing with new releases.

Also of note, in the analysis/oprofile.breakout.001 directories of any 
benchmark, you can now find oprofile call graphs (for new runs only).

Steve
