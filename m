Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:33980 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768AbcCTTbu (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Mar 2016 15:31:50 -0400
Received: by mail-io0-f176.google.com with SMTP id m184so190490194iof.1
        for <linux-btrfs@vger.kernel.org>; Sun, 20 Mar 2016 12:31:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC7HdqknOJAK+FcE53xO38G__gc42GR0GQW+chbGbDxXBt7HFA@mail.gmail.com>
References: <CAC7HdqknOJAK+FcE53xO38G__gc42GR0GQW+chbGbDxXBt7HFA@mail.gmail.com>
Date: Sun, 20 Mar 2016 13:31:49 -0600
Message-ID: <CAJCQCtQ=_iE3m6P-jH1VjzycBXXRv5QZUS2SPNeH7ZJ_ukWM-A@mail.gmail.com>
Subject: Re: moving btrfs subvolumes to new disk
From: Chris Murphy <lists@colorremedies.com>
To: Ryan Erato <rerato@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 19, 2016 at 4:58 PM, Ryan Erato <rerato@gmail.com> wrote:
> I'm having quite the time trying to move my current Gentoo install to
> an SSD. I first attempted Clonezilla, but that failed while cloning
> the btrfs partition. I then realized I could use btrfs send/receive.
>
> The partition has 2 subvolumes ROOT and ROOT/home. ROOT snapshots and
> sends without hitch, but /home consistently errors at the same point
> (from -vv output on btrfs send). btrfs send returns -2, no such file
> or directory, unexpected EOF in stream.

What's the exact command you're using for btrfs send receive for ROOT and home?


>
> # cat /etc/fstab
> /dev/sda4 /boot vfat noauto,noatime 1 2
> /dev/sda6 / btrfs defaults,noatime,compress=lzo,autodefrag,subvol=ROOT 0 0
> /dev/sda5 none swap sw 0 0
>
> # btrfs su l /
> ID 257 gen 745235 top level 5 path ROOT
> ID 258 gen 745235 top level 257 path home
> ID 498 gen 744743 top level 5 path ROOT.snap
> ID 501 gen 745043 top level 258 path home/home.snap

Nested subvolumes makes this more complicated in my opinion. You might
have better luck mounting subvolid=5 to /mnt and using a fully
qualified pathname for send.



-- 
Chris Murphy
