From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: write(2) taking 4s. (Was: Memory leak?)
Date: Sun, 17 Jul 2011 10:17:37 +0100
Message-ID: <20110717091737.GA4301@yahoo.fr>
References: <20110706081111.GA6931@yahoo.fr>
 <20110708124429.GB4284@yahoo.fr>
 <1310137241-sup-8158@shiny>
 <20110709170959.GC4294@yahoo.fr>
 <CAE5mzvhZwrtEZ8FUfcYzoMsRwuPjNDn=iCZ6_-CKaifEPZWAKA@mail.gmail.com>
 <20110709203649.GE4294@yahoo.fr>
 <1310301809-sup-9903@shiny>
 <20110710183728.GB4277@yahoo.fr>
 <20110711090121.GA2537@yahoo.fr>
 <20110716121210.GA5638@yahoo.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110716121210.GA5638@yahoo.fr>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-16 13:12:10 +0100, Stephane Chazelas:
> Still on my btrfs-based backup system. I still see one BUG()
> reached in btrfs-fixup per boot time, no memory exhaustion
> anymore. There is now however something new: write performance
> is down to a few bytes per second.
[...]

The condition that was causing that seems to have cleared by
itself this morning before 4am.

flush-btrfs-1 and sync are still in D state.

Can't really tell what cleared it. Could be when the first of
the rsyncs ended as all the other ones (and ntfsclones from nbd
devices) ended soon after

Cheers,
Stephane

