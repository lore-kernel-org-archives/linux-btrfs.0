Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:50032 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753019AbcKMPNc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Nov 2016 10:13:32 -0500
Date: Sun, 13 Nov 2016 20:13:29 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: when btrfs scrub reports errors and btrfs check --repair does
 not
Message-ID: <20161113201329.1851b992@natsu>
In-Reply-To: <20161113150629.qiz3r6no3snrufuu@merlins.org>
References: <20161108003950.GD13371@merlins.org>
        <63a1964d-f8df-413d-c088-20163f824e3d@cn.fujitsu.com>
        <20161108010600.GE13371@merlins.org>
        <977bbf2a-5d9f-f5aa-084c-4ca1d891eb72@cn.fujitsu.com>
        <20161108152429.GC24297@merlins.org>
        <f17792e9-498a-4ff0-2cc5-674ae10a01ad@cn.fujitsu.com>
        <20161109020519.GN13371@merlins.org>
        <20161111034805.svs33jawobogpzrc@merlins.org>
        <f9757f37-ab2b-87d8-3f72-80dcc968f6e8@cn.fujitsu.com>
        <20161112031708.aylnevv657w2x3dg@merlins.org>
        <20161113150629.qiz3r6no3snrufuu@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 13 Nov 2016 07:06:30 -0800
Marc MERLIN <marc@merlins.org> wrote:

> So first:
> a) find -inum returns some inodes that don't match
> b) but argh, multiple files (very different) have the same inode number, so finding
> files by inode number after scrub flagged an inode bad, isn't going to work :(

I wonder why do you even need scrub to verify file readability. Just try
reading all files by using e.g. "cfv -Crr", the read errors produced will
point you directly to files which are unreadable, without the need to lookup
them in a backward way via inum. Then just restore those from backups.

-- 
With respect,
Roman
