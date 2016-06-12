Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:36572 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932426AbcFLWAw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 12 Jun 2016 18:00:52 -0400
Received: by mail-vk0-f51.google.com with SMTP id u64so46342970vkf.3
        for <linux-btrfs@vger.kernel.org>; Sun, 12 Jun 2016 15:00:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jZUx+V+1eyw1cDpHDkudXqfLQFL9+53Lzb3f0_PGXw+Xw@mail.gmail.com>
References: <CAKzrAgRQOvpy3ZVrLHHaRQt-JcjiFSFz6HPGr1vnvBK0xy5xGg@mail.gmail.com>
 <CAPmG0jZUx+V+1eyw1cDpHDkudXqfLQFL9+53Lzb3f0_PGXw+Xw@mail.gmail.com>
From: "ojab //" <ojab@ojab.ru>
Date: Sun, 12 Jun 2016 22:00:50 +0000
Message-ID: <CAKzrAgTiN86tiiritJeov0SS38+cjjQLv3z1hk9MtTjeb2m0AQ@mail.gmail.com>
Subject: Re: Cannot balance FS (No space left on device)
To: Henk Slager <eye1tm@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 10, 2016 at 9:00 PM, Henk Slager <eye1tm@gmail.com> wrote:
> I have seldom seen an fs so full, very regular numbers :)
>
> But can you provide the output of this script:
> https://github.com/knorrie/btrfs-heatmap/blob/master/show_usage.py
>
> It gives better info w.r.t. devices and it is then easier to say what
> has to be done.
>
> But you have btrfs raid0 data (2 stripes) and raid1 metadata, and they
> both want 2 devices currently and there is only one device with place
> for your 2G chunks. So in theory you need 2 empty devices added for a
> balance to succeed. If you can allow reduces redundancy for some time,
> you could shrink the fs used space on hdd1 to half, same for the
> partition itself, add a hdd2 parttition and add that to the fs. Or
> just add another HDD.
> Then your 50Gb of deletions could get into effect if you start
> balancing. Also have a look at the balance stripe filters I would say.

So after adding another one [100Gb] disk I've successfully run `btrfs
balance` and deleted new disks without any issues.
Thanks for your help.

//wbr ojab
