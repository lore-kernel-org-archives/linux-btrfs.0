From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Some very basic questions
Date: Wed, 22 Oct 2008 09:13:15 -0400
Message-ID: <1224681195.6448.1.camel@think.oraclecorp.com>
References: <20081021132322.271ad728.skraw@ithnet.com>
	 <87vdvmdu36.fsf@basil.nowhere.org>
	 <20081021162249.30a25bcb.skraw@ithnet.com>	<48FDF67C.6080205@hp.com>
	 <20081022133615.68b66b0e.skraw@ithnet.com> <48FF1976.1050202@redhat.com>
	 <48FF24A4.4040108@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Avi Kivity <avi@redhat.com>,
	Stephan von Krawczynski <skraw@ithnet.com>,
	jim owens <jowens@hp.com>, linux-btrfs@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48FF24A4.4040108@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2008-10-22 at 09:03 -0400, Ric Wheeler wrote:
> Avi Kivity wrote:
> > Stephan von Krawczynski wrote:
> >>
> >>>    - filesystem autodetects, isolates, and (possibly) repairs errors
> >>>    - online "scan, check, repair filesystem" tool initiated by admin
> >>>    - Reliability so high that they never run that check-and-fix tool
> >>>     
> >>
> >> That is _wrong_ (to a certain extent). You _want to run_ diagnostic 
> >> tools to
> >> make sure that there is no problem. And you don't want some software 
> >> (not even
> >> HAL) to repair errors without prior admin knowledge/permission
> >
> > I think there's a place for a scrubber to continuously verify 
> > filesystem data and metadata, at low io priority, and correct any 
> > correctable errors.  The admin can read the error correction report at 
> > their leisure, and then take any action that's outside the 
> > filesystem's capabilities (like ordering and installing new disks).
> >
> Scrubbing is key for many scenarios since errors can "grow" even in 
> places where previous IO has been completed without flagging an error.
> 

We'll definitely have background scrubbing.  It is a key part of the
health of the FS I think.

-chris


