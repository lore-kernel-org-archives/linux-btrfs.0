From: Chris Mason <chris.mason@oracle.com>
Subject: Re: HP opensourced advfs from tru64 and what it means for btrfs
Date: Mon, 23 Jun 2008 14:21:09 -0400
Message-ID: <1214245269.10187.587.camel@think.oraclecorp.com>
References: <c24352ca0806230737g287de15bv5916d1c7501f06be@mail.gmail.com>
	 <20080623145026.GA13310@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain
Cc: jeffschroeder@computer.org, linux-btrfs@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080623145026.GA13310@2ka.mipt.ru>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-06-23 at 18:50 +0400, Evgeniy Polyakov wrote:
> Hi.
> 
> On Mon, Jun 23, 2008 at 07:37:32AM -0700, Jeff Schroeder (jeffschroed@gmail.com) wrote:
> > http://advfs.sourceforge.net/ HP open sourced the advfs filesystem
> > from tru64 Unix today under the gplv2.
> 
> ...
>  
> > Would it make sense to look at using any of the code from this in
> > btrfs, or would it be easier to
> > re-implement it all over again? Even though filesystems ported from
> > other Posix operating systems to Linux (Ever looked at XFS code)
> > can be ugly, this might be a way to accelerate btrfs development.
> > If nothing else, it might be interesting to see how HP solved problems
> > btrfs will soon be solving.
> 
> Sure it is interesting as studing anything new, but there is nothing in
> advfs which can prevent btrfs from success. Virtually nothing.
> Advfs is quite old technology built on top of almost 20 years old ideas
> and hardware, while the former can still be (and likely is) valid,
> hardware made significant progress.

In general, the rules that make filesystems go haven't changed in a long
time.   Disks are slow, ram is faster, and cpu is both infinitely fast
and important to share with other things running on the hardware.

There is a great deal we can learn from any long standing FS in terms of
layout optimizations, allocation policies and ease of use.

Is there code we can lift 100% from advfs?  It is hard to say for sure,
but being able to copy policy and basic algorithms is definitely
important.

-chris


