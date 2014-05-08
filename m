Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:53663 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809AbaEHWCq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 8 May 2014 18:02:46 -0400
Date: Thu, 8 May 2014 15:02:42 -0700
From: Marc MERLIN <marc@merlins.org>
To: Justin Maggard <jmaggard10@gmail.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: URGENT: my laptop's boot ssd btrfs crashed, what do you need off
 it?
Message-ID: <20140508220242.GO11401@merlins.org>
References: <20140507233959.GB11401@merlins.org>
 <536AD20E.70004@fb.com>
 <20140508004344.GE11401@merlins.org>
 <20140508013440.GH11401@merlins.org>
 <CAKgsxVR=6GTesbtqG_SAyKnpw9pxz1TZ0oOi_MB8Ej3j4-vMiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAKgsxVR=6GTesbtqG_SAyKnpw9pxz1TZ0oOi_MB8Ej3j4-vMiw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

To Chris and others, if you want anything from that filesystem, 
please let me know today, I'll destroy it tonight (12H from mow my time)
and rebuild it.
If 3.14.0 has known bugs that cause corruption, please let me know
and I'll create the new filesystem with 3.15-rc4 even if I don't love
running rc kernels on my laptop.

On Thu, May 08, 2014 at 10:40:05AM -0700, Justin Maggard wrote:
> On Wed, May 7, 2014 at 6:34 PM, Marc MERLIN <marc@merlins.org> wrote:
> > Can btrfs restore be used to navigate the filesystem and look for files and patterns
> > without dumping the entire filesystem, which I don't have room for?
> 
> On recent versions of btrfs-progs, you can run btrfs restore with both
> the verbose and dry-run options to see what it finds, without actually
> restoring anything.

Interesting, the man page for 3.14 doesn't show that, but usage does.

Anyway, I had:
legolas:/# /sbin/btrfs-find-root /dev/mapper/disk1
Super think's the tree root is at 828930883584, chunk root 20979712
Well block 12585312256 seems great, but generation doesn't match, have=410782, want=415424 level 0
(...)
Well block 828888629248 seems great, but generation doesn't match, have=415420, want=415424 level 0
Found tree root at 828930887680 gen 415424 level 0
legolas:/#

But no luck with it:
legolas:/var/local/space/nobck/restore# btrfs restore -D -v -t 828930887680 /dev/mapper/disk1 .
Couldn't setup extent tree
Couldn't setup device tree
Couldn't read fs root: -2
legolas:/var/local/space/nobck/restore# btrfs restore -D -v  /dev/mapper/disk1 .
Check tree block failed, want=828930883584, have=10983188636980216968
Check tree block failed, want=828930883584, have=10983188636980216968
Check tree block failed, want=828930883584, have=12509109177217855588
Check tree block failed, want=828930883584, have=12509109177217855588
Check tree block failed, want=828930883584, have=12509109177217855588
read block failed check_tree_block
Couldn't read tree root
Check tree block failed, want=828930883584, have=10983188636980216968
Check tree block failed, want=828930883584, have=10983188636980216968
Check tree block failed, want=828930883584, have=12509109177217855588
Check tree block failed, want=828930883584, have=12509109177217855588
Check tree block failed, want=828930883584, have=12509109177217855588
read block failed check_tree_block
Error opening tree root

Am I doing this wrong? Why is restore not able to use the tree root I gave it?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
