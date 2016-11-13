Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57083 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933689AbcKMPw5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Nov 2016 10:52:57 -0500
Date: Sun, 13 Nov 2016 07:52:53 -0800
From: Marc MERLIN <marc@merlins.org>
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20161113155253.gu7rwjqsvdsrvat7@merlins.org>
References: <20161108010600.GE13371@merlins.org>
 <977bbf2a-5d9f-f5aa-084c-4ca1d891eb72@cn.fujitsu.com>
 <20161108152429.GC24297@merlins.org>
 <f17792e9-498a-4ff0-2cc5-674ae10a01ad@cn.fujitsu.com>
 <20161109020519.GN13371@merlins.org>
 <20161111034805.svs33jawobogpzrc@merlins.org>
 <f9757f37-ab2b-87d8-3f72-80dcc968f6e8@cn.fujitsu.com>
 <20161112031708.aylnevv657w2x3dg@merlins.org>
 <20161113150629.qiz3r6no3snrufuu@merlins.org>
 <20161113201329.1851b992@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161113201329.1851b992@natsu>
Subject: Re: when btrfs scrub reports errors and btrfs check --repair does not
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 13, 2016 at 08:13:29PM +0500, Roman Mamedov wrote:
> On Sun, 13 Nov 2016 07:06:30 -0800
> Marc MERLIN <marc@merlins.org> wrote:
> 
> > So first:
> > a) find -inum returns some inodes that don't match
> > b) but argh, multiple files (very different) have the same inode number, so finding
> > files by inode number after scrub flagged an inode bad, isn't going to work :(
> 
> I wonder why do you even need scrub to verify file readability. Just try
> reading all files by using e.g. "cfv -Crr", the read errors produced will
> point you directly to files which are unreadable, without the need to lookup
> them in a backward way via inum. Then just restore those from backups.

I could read the files, but we're talking about maybe 100 million files?
that would take a while... (and most of them are COW copies of the same
physical data), so scrub is _much_ faster.

Scrub is also reporting issues not related to files, but data structures
it seems, while repair is not fiding them.

As for the data, it's a backup device, so I can just wipe it, but again,
I'm using this as an example of how I would simply bring a drive back to
a clean state, and that's not pretty right now.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
