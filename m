Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:54416 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753833AbcKDJAr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 4 Nov 2016 05:00:47 -0400
Date: Fri, 4 Nov 2016 14:00:43 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Marc MERLIN <marc@merlins.org>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Hugo Mills <hugo@carfax.org.uk>,
        linux-btrfs@vger.kernel.org
Subject: Re: btrfs check --repair: ERROR: cannot read chunk root
Message-ID: <20161104140043.5d739dc9@natsu>
In-Reply-To: <20161104080113.GG3529@merlins.org>
References: <20161031054719.GN28648@merlins.org>
        <b31eaf2d-b339-6163-0108-28d1586c05e5@cn.fujitsu.com>
        <20161031062509.GO28648@merlins.org>
        <0c9e25b1-c8e1-6300-0c79-e9e3e8fd0f52@cn.fujitsu.com>
        <20161031063737.GP28648@merlins.org>
        <81e30812-be45-b4ff-3bf2-c79e805d445a@cn.fujitsu.com>
        <20161031084412.GI16645@carfax.org.uk>
        <20161031150422.GQ28648@merlins.org>
        <38fa8b04-ec2d-884f-e03c-8bc2fb888efb@cn.fujitsu.com>
        <20161101042140.atn73lqehgpqslgz@merlins.org>
        <20161104080113.GG3529@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 4 Nov 2016 01:01:13 -0700
Marc MERLIN <marc@merlins.org> wrote:

> Basically I have this:
> sde                            8:64   0   3.7T  0 
> └─sde1                         8:65   0   3.7T  0 
>   └─md5                        9:5    0  14.6T  0 
>     └─bcache0                252:0    0  14.6T  0 
>       └─crypt_bcache0 (dm-0) 253:0    0  14.6T  0 
> 
> I'll try dd'ing the md5 directly now, but that's going to take another 2 days :(
> 
> That said, given that almost half the device is not readable from user space
> for some reason, that would explain why btrfs check is failing. Obviously it
> can't do its job if it can't read blocks.

I don't see anything to support the notion that "half is unreadable", maybe
just a 512-byte sector is unreadable -- but that would be enough to make
regular dd bail out -- which is why you should be using dd_rescue for this,
not regular dd. Assuming you just want to copy over as much data as possible,
and not simply test if dd fails or not (but in any case dd_rescue at least
would not fail instantly and would tell you precise count of how much is
unreadable).

There is "GNU ddrescue" and "dd_rescue", I liked the first one better, but
they both work on a similar principle.

Also didn't you recently have issues with bad block lists on mdadm. This
mysterious "unreadable and nothing in dmesg" does appear to be a continuation
of that.

-- 
With respect,
Roman
