From: Chris Mason <chris.mason@oracle.com>
Subject: Re: More performance results
Date: Tue, 03 Feb 2009 11:38:28 -0500
Message-ID: <1233679109.7246.30.camel@think.oraclecorp.com>
References: <49871813.8090309@austin.ibm.com>
	 <f24d23310902030532w6cad0b6v209951bb24fba388@mail.gmail.com>
	 <1233673296.7246.4.camel@think.oraclecorp.com>
	 <49885F0E.1050705@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: debian developer <debiandev@gmail.com>, linux-btrfs@vger.kernel.org
To: Steven Pratt <slpratt@austin.ibm.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <49885F0E.1050705@austin.ibm.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2009-02-03 at 09:13 -0600, Steven Pratt wrote:
> Chris Mason wrote:
> > On Tue, 2009-02-03 at 19:02 +0530, debian developer wrote:
> >   
> >> On Mon, Feb 2, 2009 at 9:28 PM, Steven Pratt <slpratt@austin.ibm.com> wrote:
> >>     
> >>> Finally cleared out a backlog of results to upload.  Main performance page is updated with all the links.  (http://btrfs.boxacle.net/)  Most recent results are on 2.6.29-rc2. As usual see analysis directory of results for oprofile, including call graphs.
> >>>
> >>> Single disk results are not too bad.  Raid still falls apart on any write heavy workload.
> >>>       
> >> Would you please mind explaining how bad the results are and
> >> how much more this needs to be improved for Btrfs to be perfomance
> >> wise acceptable?
> >>
> >> I see that Btrfs almost everywhere lacks XFS and others in some cases.
> >>     
> >
> > These benchmarks are great because they hammer on some of the worst
> > cases code in btrfs.  The mail-server benchmark for example isn't quite
> > a mail server workload because it doesn't fsync the files to disk.
> >   
> Actually it does.  We fixed this after the first round was posted.

Oh, sorry I thought that was put into a different run with fsync on.
So, the mail server benchmark I've been tuning locally doesn't have
fsync on ;)  Deletes are still the slow part on that one.

Thanks for the correction though, I'll look at the fsync perf once the
non-fsync perf is faster.

-chris


