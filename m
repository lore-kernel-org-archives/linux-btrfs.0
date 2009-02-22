From: Dmitri Nikulin <dnikulin@gmail.com>
Subject: Re: ssd optimised mode
Date: Sun, 22 Feb 2009 12:07:11 +1100
Message-ID: <3a7f57190902211707h37ff1478vdc0e5ffff66fa4da@mail.gmail.com>
References: <934e480c0902200326m7647d87cq28bfa1675ef012f4@mail.gmail.com>
	 <20090220160134.GE24890@unused.rdu.redhat.com>
	 <1235147425.13249.16.camel@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1235147425.13249.16.camel@think.oraclecorp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 21, 2009 at 3:30 AM, Chris Mason <chris.mason@oracle.com> wrote:
> The short answer is that in ssd mode we don't try to avoid random reads.

In the ideal future where SSDs can be run without a flimsy hardware
FTL, and btrfs can use something like ubi directly, would SSD mode
also be able to enable more intelligent wear levelling and safer use
of eraseblocks?

I've read that one of the potentially crippling limitations of ZFS is
that even its reliability features depend largely on being able to
perform atomic writes, which are currently impossible (?) on flash
media where a block has to be erased before it can be updated, clearly
not an atomic operation. Is there any solution to this that doesn't
depend on a battery backup? Clearly it's not something a filesystem
can practically solve.

--
Dmitri Nikulin

Centre for Synchrotron Science
Monash University
Victoria 3800, Australia
