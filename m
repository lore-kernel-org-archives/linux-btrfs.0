Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:34865 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751975AbdIANwI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 09:52:08 -0400
Received: by mail-lf0-f49.google.com with SMTP id g18so1096895lfl.2
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Sep 2017 06:52:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170831163656.6be88191@natsu>
References: <556e7650-8556-d5ca-273e-6c158c1d032e@prismatelecomtesting.com> <20170831163656.6be88191@natsu>
From: Juan Orti Alcaine <j.orti.alcaine@gmail.com>
Date: Fri, 1 Sep 2017 15:52:06 +0200
Message-ID: <CAC+fKQXozVX4OsKOVxPEdRPkO=5iakEJenaxLHoaQ4FieSUmLA@mail.gmail.com>
Subject: Re: mount time for big filesystems
To: Roman Mamedov <rm@romanrm.net>
Cc: Marco Lorenzo Crociani <marcoc@prismatelecomtesting.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-08-31 13:36 GMT+02:00 Roman Mamedov <rm@romanrm.net>:
> If you could implement SSD caching in front of your FS (such as lvmcache or
> bcache), that would work wonders for performance in general, and especially
> for mount times. I have seen amazing results with lvmcache (of just 32 GB) for
> a 14 TB FS.

I'm thinking about adding a SSD for my 4 disks RAID1 filesystem, but I
have doubts about how to correctly do it in a multidevice filesystem.

I guess I should make 4 partitions on the SSD and pair them with my
backing devices, then create the btrfs on top of bcache0, bcache1,...
is this the right way to do it?
