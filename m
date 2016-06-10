Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:36827 "EHLO
	mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbcFJVde (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 17:33:34 -0400
Received: by mail-vk0-f50.google.com with SMTP id u64so3165071vkf.3
        for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 14:33:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPmG0jZUx+V+1eyw1cDpHDkudXqfLQFL9+53Lzb3f0_PGXw+Xw@mail.gmail.com>
References: <CAKzrAgRQOvpy3ZVrLHHaRQt-JcjiFSFz6HPGr1vnvBK0xy5xGg@mail.gmail.com>
 <CAPmG0jZUx+V+1eyw1cDpHDkudXqfLQFL9+53Lzb3f0_PGXw+Xw@mail.gmail.com>
From: "ojab //" <ojab@ojab.ru>
Date: Fri, 10 Jun 2016 21:33:31 +0000
Message-ID: <CAKzrAgTngBtK+eRGFh75GZ3MmuBKYyjbQXjD_LBhE8J-TuN0yg@mail.gmail.com>
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

Output of show_usage.py:
https://gist.githubusercontent.com/ojab/850276af6ff3aa566b8a3ce6ec444521/raw/4d77e02d556ed0edb0f9823259f145f65e80bc66/gistfile1.txt
Looks like I only have smaller spare drives at the moment (largest is
100GB), is it ok to use? Or there is some minimal drive size needed
for my setup?

//wbr ojab
