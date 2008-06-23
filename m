From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: HP opensourced advfs from tru64 and what it means for btrfs
Date: Mon, 23 Jun 2008 22:45:34 +0400
Message-ID: <20080623184532.GA27013@2ka.mipt.ru>
References: <c24352ca0806230737g287de15bv5916d1c7501f06be@mail.gmail.com> <20080623145026.GA13310@2ka.mipt.ru> <1214245269.10187.587.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: jeffschroeder@computer.org, linux-btrfs@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1214245269.10187.587.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 23, 2008 at 02:21:09PM -0400, Chris Mason (chris.mason@oracle.com) wrote:
> > Sure it is interesting as studing anything new, but there is nothing in
> > advfs which can prevent btrfs from success. Virtually nothing.
> > Advfs is quite old technology built on top of almost 20 years old ideas
> > and hardware, while the former can still be (and likely is) valid,
> > hardware made significant progress.
> 
> In general, the rules that make filesystems go haven't changed in a long
> time.   Disks are slow, ram is faster, and cpu is both infinitely fast
> and important to share with other things running on the hardware.

I believe if things are that simple, you would not start btrfs? :)

> There is a great deal we can learn from any long standing FS in terms of
> layout optimizations, allocation policies and ease of use.

Sure.

> Is there code we can lift 100% from advfs?  It is hard to say for sure,
> but being able to copy policy and basic algorithms is definitely
> important.

There was similar xfs migration story, and still there is btrfs.

I completely agree that there might be some very interesting ideas
implemented, but I believe that all them we could already know about,
and porting theirs implementation into the new FS will not be easy
steps. I fully appreciate advfs became open and belive that it will get
some commnunity support, but I think that we are already behind its
milestone.

-- 
	Evgeniy Polyakov
