Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:46731 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737AbbBGAOc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Feb 2015 19:14:32 -0500
Received: by mail-yk0-f175.google.com with SMTP id 10so3136244ykt.6
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Feb 2015 16:14:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <mb3f86$tum$1@ger.gmane.org>
References: <mau7vs$pjj$1@ger.gmane.org>
	<CAJCQCtSXJZ4paKiZBNDOp-yKccrLbizmGDj_8y5k5EC-9DFjXg@mail.gmail.com>
	<54D2E62E.7080208@pobox.com>
	<CAJCQCtSLBg7-XoVjTfDq5PbZ-dk1WXeXGT2YEbQYNNc0VoSu-A@mail.gmail.com>
	<mb0jp0$pnd$1@ger.gmane.org>
	<CAJCQCtT1pSrFEU7Q0qspNkqzY9naDHxzzyE5y3fyqgZqqkT_vA@mail.gmail.com>
	<mb0s1l$3ta$1@ger.gmane.org>
	<CAJCQCtRHsiau97r66O9PC6O0mK7Yafc3aE2HX=4bT-w4nw8OZg@mail.gmail.com>
	<mb3f86$tum$1@ger.gmane.org>
Date: Fri, 6 Feb 2015 17:14:31 -0700
Message-ID: <CAJCQCtQuk0XWWBcW4j=CBJ=GBgd9jS-PKCki7zOH2cNOuroanA@mail.gmail.com>
Subject: Re: Btrfs subvolume question
From: Chris Murphy <lists@colorremedies.com>
To: Markus Moeller <huaraz@moeller.plus.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 6, 2015 at 3:29 PM, Markus Moeller <huaraz@moeller.plus.com> wrote:
> So what I don't understand which process created the sub volumes.

Yast had to have done it. It did all the partitioning, creation of the
file system, and it created fstab.


> I fear if
> I start again it will be the same.

Don't check the LVM option. I don't have the installer UI right in
front of me so I don't know exactly where it is or what it's called,
but it's not enabled by default because I've done a default openSUSE
13.2 installation and it did use Btrfs and created a pile of
subvolumes, but it didn't use LVM at all.


> The OpenSuse YAST2 Partition tool does
> not show any subvolumes.

That sounds like a feature request. They're clearly there.



-- 
Chris Murphy
