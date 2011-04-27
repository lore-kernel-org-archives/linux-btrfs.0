From: Peter Stuge <peter@stuge.se>
Subject: Re: btrfs-convert crashes
Date: Thu, 28 Apr 2011 01:36:21 +0200
Message-ID: <20110427233621.30135.qmail@stuge.se>
References: <4DB7A796.90800@cox.net> <BANLkTimA-8YAvAFS257tG-j=Mf1vR-N5ig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTimA-8YAvAFS257tG-j=Mf1vR-N5ig@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Yan, Zheng  wrote:
> > 'btrfs-convert /dev/sdc1' .. segfaulted.
> 
> The crash was caused by the hard links per directory limit in btrfs.
> In short, your ext4 is not convertible.

The failure mode is of course unacceptable. Does btrfs-convert have a
dry-run mode which could be used to check that actual convert will
not crash on top of a pile of random bits?


//Peter
