Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f172.google.com ([74.125.82.172]:36989 "EHLO
        mail-ot0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751043AbdKTCD5 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 19 Nov 2017 21:03:57 -0500
Received: by mail-ot0-f172.google.com with SMTP id s4so6449294ote.4
        for <linux-btrfs@vger.kernel.org>; Sun, 19 Nov 2017 18:03:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <a61eeda7-af07-e140-ccd9-d288931f07fb@gmail.com>
References: <a61eeda7-af07-e140-ccd9-d288931f07fb@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 19 Nov 2017 19:03:55 -0700
Message-ID: <CAJCQCtSLG5hXikEiBD4OF5G+EfKgyALaynqivBvCaWLpEYQjEw@mail.gmail.com>
Subject: Re: uncorrectable errors in Raid 10
To: Steffen Sindzinski <stesind@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 19, 2017 at 12:31 PM, Steffen Sindzinski <stesind@gmail.com> wrote:

> [57830.611730] BTRFS warning (device sdc2): checksum/header error at logical
> 17478699876352 on dev /dev/sdd2, sector 338986176: metadata leaf (level 0)
> in tree 318
> [57830.611732] BTRFS warning (device sdc2): checksum/header error at logical
> 17478699876352 on dev /dev/sdd2, sector 338986176: metadata leaf (level 0)
> in tree 318

The same leaf is corrupt in the same physical sector on two devices.
I'm guessing the checksum was computed incorrectly and written twice,
affecting both copies. I doubt it's a device problem. It might be
useful to look through the archives specifically for checksum header
error, it's kinda interesting Btrfs knows the problem is specifically
there.

What do you get for:

btrfs-debut-tree -b 17478699876352 /dev/sdd2

I think the problem is isolated but you're probably best off to
freshen up backups now while you can. Yes you can use restore to get
data off the volume if you don't already have backups. And as for
btrfs check --repair, only do that once you have backups and you're
prepared to lose the file system.



-- 
Chris Murphy
