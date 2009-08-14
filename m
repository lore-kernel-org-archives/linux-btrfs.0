From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [2.6.31-rc6, BTRFS] potential memory leaks...
Date: Fri, 14 Aug 2009 11:05:15 -0400
Message-ID: <20090814150515.GB28790@think>
References: <6278d2220908140803g554ab931o58672a1b4c11e245@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux BTRFS <linux-btrfs@vger.kernel.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932470AbZHNPFW@vger.kernel.org>
In-Reply-To: <6278d2220908140803g554ab931o58672a1b4c11e245@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 14, 2009 at 04:03:04PM +0100, Daniel J Blueman wrote:
> There is good chance that the BTRFS kmemleak reports using 2.6.31-rc6
> [1] are false-positives, due to the overwriting of the static pointers
> [2]. Does this ring true with anyone else?

If these were real leaks you'd see errors during rmmod.  They should be
false positives.

-chris
