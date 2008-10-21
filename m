From: Steven Pratt <slpratt@austin.ibm.com>
Subject: BTRFS Performance page
Date: Tue, 21 Oct 2008 17:20:03 -0500
Message-ID: <48FE5593.2080209@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

As discussed on the BTRFS conference call, myself and Kevin Corry have 
set up some test machines for the purpose of doing performance testing 
on BTRFS.  The intent is to have a semi permanent setup that we can use 
to test new features and code drops in BTRFS as well as to do 
comparisons to other file systems.  The systems are pretty much fully 
automated for execution, so we should be able to crank out large numbers 
of different benchmarks as well as keep up with GIT changes.

The data is hosted at http://btrfs.boxacle.net/. So far we have the data 
for the single disk tests uploaded. We should be able to upload results 
from the larger RAID config tomorrow.

Initial tests were done with the FFSB benchmark and we picked 5 common 
workloads; create, random and sequential read, random write, and a mail 
server emulation.  We plan to expand this based on feedback to include 
more FFSB tests and/or other workloads.

All runs have complete analysis data with them (iostat, mpstat, 
oprofile, sar), as well as the FFSB profiles that can be used to 
recreate any test we ran. We also have collected blktrace data but not 
uploaded due to size.

Please follow the results link on the bottom of the main page to get to 
the current results.  Let me know what you like or don't like.   I will 
post again when we get the RAID data uploaded.


Steve
