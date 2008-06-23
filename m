From: Chris Mason <chris.mason@oracle.com>
Subject: Re: HP opensourced advfs from tru64 and what it means for btrfs
Date: Mon, 23 Jun 2008 14:59:12 -0400
Message-ID: <1214247552.10187.594.camel@think.oraclecorp.com>
References: <c24352ca0806230737g287de15bv5916d1c7501f06be@mail.gmail.com>
	 <20080623145026.GA13310@2ka.mipt.ru>
	 <1214245269.10187.587.camel@think.oraclecorp.com>
	 <20080623184532.GA27013@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain
Cc: jeffschroeder@computer.org, linux-btrfs@vger.kernel.org
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20080623184532.GA27013@2ka.mipt.ru>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2008-06-23 at 22:45 +0400, Evgeniy Polyakov wrote:
> On Mon, Jun 23, 2008 at 02:21:09PM -0400, Chris Mason (chris.mason@oracle.com) wrote:
> > > Sure it is interesting as studing anything new, but there is nothing in
> > > advfs which can prevent btrfs from success. Virtually nothing.
> > > Advfs is quite old technology built on top of almost 20 years old ideas
> > > and hardware, while the former can still be (and likely is) valid,
> > > hardware made significant progress.
> > 
> > In general, the rules that make filesystems go haven't changed in a long
> > time.   Disks are slow, ram is faster, and cpu is both infinitely fast
> > and important to share with other things running on the hardware.
> 
> I believe if things are that simple, you would not start btrfs? :)
> 

Grin, just because everyone knows the rules doesn't mean you shouldn't
try playing.  SSD does change the dynamics as well in ways that I think
btrfs is best suited to handle.

The idea is that well established filesystems can teach us quite a lot
about layout, and about the optimizations that were added in response to
customer demand.  Having the code to these optimizations is very useful.

-chris


