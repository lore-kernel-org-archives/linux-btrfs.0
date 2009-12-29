From: Gregory Maxwell <gmaxwell@gmail.com>
Subject: Re: l2arc-like ability in btrfs
Date: Tue, 29 Dec 2009 18:09:10 -0500
Message-ID: <e692861c0912291509o4b5cd170oc15f5472c73ae5d2@mail.gmail.com>
References: <1262127361.3705.9.camel@gandalfpc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Hans van den Bogert <gandalf@unit-westland.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1262127361.3705.9.camel@gandalfpc>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 29, 2009 at 5:56 PM, Hans van den Bogert
<gandalf@unit-westland.nl> wrote:
> Will btrfs in the future implement a read cache like zfs has with l2arc,
> following it's hybrid storage concept.
> This would take away the hassle of choosing what and what not should be
> on your SSD, it would speed up the things you do most. And not what you
> did a lot a week ago. It should be persistent between boots so your boot
> sequence would benefit too.

A useful link for those who don't track all the details of ZFS development:
http://blogs.sun.com/brendan/entry/test
