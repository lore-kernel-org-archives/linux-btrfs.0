Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f46.google.com ([209.85.192.46]:32862 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754018AbcBZMPy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Feb 2016 07:15:54 -0500
Received: by mail-qg0-f46.google.com with SMTP id d32so7489947qgd.0
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Feb 2016 04:15:53 -0800 (PST)
Subject: Re: upgrading kernel 3.13 to 3.16
To: Vytautas D <vytdau@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAO5K3OdzXgXpSNqCOqvMwVgQWiEF9p91ymB+uXjFRCCK24QWZg@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56D041AC.6070802@gmail.com>
Date: Fri, 26 Feb 2016 07:14:36 -0500
MIME-Version: 1.0
In-Reply-To: <CAO5K3OdzXgXpSNqCOqvMwVgQWiEF9p91ymB+uXjFRCCK24QWZg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-26 05:50, Vytautas D wrote:
> Hi all,
>
> Are there any known issues upgrading btrfs running ubuntu kernel 3.13
> to 3.16 ? System was once converted from ext4 using btrfs-convert (
> btrfs-progs 3.17 ).
>
> The commit that worries me is following:
> *  Btrfs: incompatible format change to remove hole extents (+373/-56)
> ( http://linux-btrfs.vger.kernel.narkive.com/syNRZbHS/patch-btrfs-incompatible-format-change-to-remove-hole-extents-v3#post1
> )
>
> would this block me from reverting system with a snapshot back to kernel 3.13 ?
> After upgrade would the system continue writing more metadata ?
That particular commit also added a flag to control whether or not newly 
written metadata uses that feature.  As long as you don't manually 
enable this flag, you should be perfectly fine WRT that change.

