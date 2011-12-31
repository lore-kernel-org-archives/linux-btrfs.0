From: Edward Ned Harvey <kernel@nedharvey.com>
Subject: RE: Encryption implementation like ZFS?
Date: Sat, 31 Dec 2011 11:01:29 -0500
Message-ID: <000701ccc7d5$84747d50$8d5d77f0$@nedharvey.com>
References: <CAELiMBN7vPQ=42eNwT3oGztWS-666RrpzDzv7nDF_LX+0gjxhQ@mail.gmail.com>	<CANZ96zUydMMYSGoX9QM8p5KSE_17faDCM9ruEeT9peO4_q181A@mail.gmail.com> <CAELiMBP9g52fHQv=ur0Kjk+=kO9DWJMCh20RL+-2s_0pS7GVXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: <linux-btrfs@vger.kernel.org>
To: "'Sandra Schlichting'" <littlesandra88@gmail.com>,
	"Billy Crook" <billycrook@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAELiMBP9g52fHQv=ur0Kjk+=kO9DWJMCh20RL+-2s_0pS7GVXg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Sandra Schlichting
> 
> TRIM pass-through for SSD's. With dmcrypt on an SSD write performance
> is very slow.

That's a relative term.  Suppose the SSD does 60x higher random IOPS than
the HDD, in an optimal configuration.  Without support for TRIM, it will
degrade something like 2x to 4x, so you will only get 15x to 30x higher
random write IOPS than the HDD.  Remember also, that the whole TRIM topic is
only applicable to writes.  Regardless of TRIM or encryption, your random
read IOPS are going to be far higher with the SSD.  The full 60x random read
IOPS regardless of TRIM.

But random IOPS is only one measure... If the SSD and the HDD are about the
same sequential throughput in the optimal configuration, then the SSD
degrades down to 1/2  to 1/4 the speed of the HDD for sequential writes in
the absence of TRIM.  This is a very sticky subject - because what the mfgr
publishes for specs on the SSD are usually the out-of-the-box performance
specs, under ideal conditions.  In reality, it's rarely even on the same
order as the real life measured performance after your system has been in
use for a few weeks.  YMMV dramatically.

Quickly looking at commodity SSD's on the market right now, I see claims of
130 to 200 MB/sec sustained.  This compares to HDD's which are right around
1.0Gbit/sec = 125 MB/sec.  In my personal experience, I would say the 130 to
200 MB is only true for a brand new SSD in optimal configuration.  I would
expect these drives in real life usage to be very comparable to the HDD for
sequential reads, and writes if TRIM is supported, but the SSD significantly
slower than the HDD for sequential writes without TRIM.


> From: linux-btrfs-owner@vger.kernel.org [mailto:linux-btrfs-
> owner@vger.kernel.org] On Behalf Of Billy Crook
> 
> Good point.  I'm actually very close to moving from magnetic to SSD
> storage for my btrfs volumes.  Would my luks layer offset the majority
> of any advantage I might otherwise see from SSD?  I'd be happy just to
> eliminate seektime.

If you mostly do random reads, random writes, or sequential reads, then
you'll get better performance with the SSD, regardless of your encryption.
For random writes, the SSD will always be better than the HDD, but how many
times faster is determined by support for TRIM.  If you do sequential
writes, then you'll get comparable performance SSD vs HDD when you have no
encryption, or you can support TRIM and background garbage collection.  If
you do sequential writes and cannot support TRIM, then the HDD will probably
outperform the SSD significantly.


