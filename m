From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BTRFS Performance page
Date: Wed, 22 Oct 2008 11:19:28 -0400
Message-ID: <1224688768.6448.63.camel@think.oraclecorp.com>
References: <48FE5593.2080209@austin.ibm.com>
	 <48FF4028.5080109@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF4028.5080109@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-10-22 at 10:00 -0500, Steven Pratt wrote:
> Steven Pratt wrote:
> > As discussed on the BTRFS conference call, myself and Kevin Corry have 
> > set up some test machines for the purpose of doing performance testing 
> > on BTRFS.  The intent is to have a semi permanent setup that we can 
> > use to test new features and code drops in BTRFS as well as to do 
> > comparisons to other file systems.  The systems are pretty much fully 
> > automated for execution, so we should be able to crank out large 
> > numbers of different benchmarks as well as keep up with GIT changes.
> >
> > The data is hosted at http://btrfs.boxacle.net/. So far we have the 
> > data for the single disk tests uploaded. We should be able to upload 
> > results from the larger RAID config tomorrow.
> >
> > Initial tests were done with the FFSB benchmark and we picked 5 common 
> > workloads; create, random and sequential read, random write, and a 
> > mail server emulation.  We plan to expand this based on feedback to 
> > include more FFSB tests and/or other workloads.
> >
> > All runs have complete analysis data with them (iostat, mpstat, 
> > oprofile, sar), as well as the FFSB profiles that can be used to 
> > recreate any test we ran. We also have collected blktrace data but not 
> > uploaded due to size.
> >

I'll try to reproduce things here, but I might end up asking for some of
the blktrace data.

> > Please follow the results link on the bottom of the main page to get 
> > to the current results.  Let me know what you like or don't like.   I 
> > will post again when we get the RAID data uploaded.
> RAID data is now uploaded.  The config used is 136 15k rpm fiber disks 
> in 8 arrays all striped together with DM.  These results are not as 
> favorable to BTRFS, as there seem to be some major issues with random 
> write and mail server workloads.
> 
> http://btrfs.boxacle.net/repository/raid/Initial-compare/Initial-Compare-RAID0.html
> 

I need to look harder at the mail server workload, my initial guess is
that I'm doing too much metadata readahead in these effectively random
operations.

If I'm reading the config correctly, the random write workload does
this:

1) create a file sequentially
2) do buffered random writes to the file

Since buffered writeback happens via pdflush, the IO isn't actually as
random as you would expect.  Pages are written in file offset order,
which actually corresponds to disk order.

When btrfs is doing COW, file offset order maps to random order on disk,
leading to much lower tput.  The nocow results should be better than
they are, and I'll see what I can do about the cow results too.

-chris


