From: Chris Mason <chris.mason@oracle.com>
Subject: Re: ssd optimised mode
Date: Mon, 23 Feb 2009 09:33:13 -0500
Message-ID: <1235399593.11205.15.camel@think.oraclecorp.com>
References: <934e480c0902200326m7647d87cq28bfa1675ef012f4@mail.gmail.com>
	 <20090220160134.GE24890@unused.rdu.redhat.com>
	 <1235147425.13249.16.camel@think.oraclecorp.com>
	 <3a7f57190902211707h37ff1478vdc0e5ffff66fa4da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Dmitri Nikulin <dnikulin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3a7f57190902211707h37ff1478vdc0e5ffff66fa4da@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2009-02-22 at 12:07 +1100, Dmitri Nikulin wrote:
> On Sat, Feb 21, 2009 at 3:30 AM, Chris Mason <chris.mason@oracle.com> wrote:
> > The short answer is that in ssd mode we don't try to avoid random reads.
> 
> In the ideal future where SSDs can be run without a flimsy hardware
> FTL, and btrfs can use something like ubi directly, would SSD mode
> also be able to enable more intelligent wear levelling and safer use
> of eraseblocks?

I think this kind of future is less and less likely.  SSD makers are
going to differentiate themselves via their FTL, and they are not going
to give the OS the chance to mess around with the flash directly.

There will surely be exceptions, but I don't think we're going to find
them in a dell any time soon.

> 
> I've read that one of the potentially crippling limitations of ZFS is
> that even its reliability features depend largely on being able to
> perform atomic writes, which are currently impossible (?) on flash
> media where a block has to be erased before it can be updated, clearly
> not an atomic operation. Is there any solution to this that doesn't
> depend on a battery backup? Clearly it's not something a filesystem
> can practically solve.

I'm sure that some early flash drives got this wrong, but the crummy
drives will eventually drop out of the market as the reliable ones gain
traction.

-chris


