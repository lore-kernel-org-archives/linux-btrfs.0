From: Chris Mason <chris.mason@oracle.com>
Subject: Re: BTRFS Performance page
Date: Wed, 22 Oct 2008 10:05:48 -0400
Message-ID: <1224684348.6448.46.camel@think.oraclecorp.com>
References: <48FE5593.2080209@austin.ibm.com>
	 <20081022001437.GA23949@think.oraclecorp.com>
	 <48FF3072.7050404@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF3072.7050404@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-10-22 at 08:53 -0500, Steven Pratt wrote:
> Chris Mason wrote:
> > On Tue, Oct 21, 2008 at 05:20:03PM -0500, Steven Pratt wrote:
> >   
> >> As discussed on the BTRFS conference call, myself and Kevin Corry have  
> >> set up some test machines for the purpose of doing performance testing  
> >> on BTRFS.  The intent is to have a semi permanent setup that we can use  
> >> to test new features and code drops in BTRFS as well as to do  
> >> comparisons to other file systems.  The systems are pretty much fully  
> >> automated for execution, so we should be able to crank out large numbers  
> >> of different benchmarks as well as keep up with GIT changes.
> >>
> >> The data is hosted at http://btrfs.boxacle.net/. So far we have the data  
> >> for the single disk tests uploaded. We should be able to upload results  
> >> from the larger RAID config tomorrow.
> >>
> >> Initial tests were done with the FFSB benchmark and we picked 5 common  
> >> workloads; create, random and sequential read, random write, and a mail  
> >> server emulation.  We plan to expand this based on feedback to include  
> >> more FFSB tests and/or other workloads.
> >>
> >> All runs have complete analysis data with them (iostat, mpstat,  
> >> oprofile, sar), as well as the FFSB profiles that can be used to  
> >> recreate any test we ran. We also have collected blktrace data but not  
> >> uploaded due to size.
> >>
> >> Please follow the results link on the bottom of the main page to get to  
> >> the current results.  Let me know what you like or don't like.   I will  
> >> post again when we get the RAID data uploaded.
> >>     
> >
> > Very interesting data, thank you for posting this.  The first comment
> > I'll make is that -o nodatacow requires -o nodatasum.  The sums aren't
> > valid without the cow.
> >   
> Thought that might be the case.  Ok, we will drop this variation.
> 
> > The FFSB mail server workload, does it do fsync writes?
> >   
> No, but we have the ability to add that if we choose.
> 
I'd be interested in it at least.

> > For the sequential read workload, I'm guessing (hoping) the files are
> > created in parallel?
> >   
> Sorry, setup is still single threaded.

Ok, I'll try to reproduce these results.  Thanks.

-chris


