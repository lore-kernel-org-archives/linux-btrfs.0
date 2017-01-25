Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:33783 "EHLO
        mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752197AbdAYUug (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 25 Jan 2017 15:50:36 -0500
Received: by mail-vk0-f46.google.com with SMTP id k127so141896254vke.0
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Jan 2017 12:50:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2987570c-aeb2-e497-ee9f-c32b8a0fb3ff@cn.fujitsu.com>
References: <2987570c-aeb2-e497-ee9f-c32b8a0fb3ff@cn.fujitsu.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Thu, 26 Jan 2017 02:19:54 +0530
Message-ID: <CAKuJGC9M245VceSBDEXhHe+yvLoXrNSZzU+i8DC6Kpzvu5+zkA@mail.gmail.com>
Subject: Re: [RFC] btrfs-progs: btrfs-corrupt-block refactor
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Qu,

I think it will be a good idea to have corruption log. It should take
--log or --verbose

btrfs-corrupt-block --log=/path/to/logfile

it should record original state of target object before the
corruption. For ex: when we try to corrupt nlink field of
/data/file.txt Log should have entries like:

--
Found /data/file.txt with inode:257
Found field:nlink value:1
Corruption done.
--

This will make debugging easier if debug-tree shows same output before
and after the corruption. We can check the logs figure-out whether
corruption exactly happened on specific object/field or not.


>    "data" options are:
>      "--bytenr BYTENR"
>         Mandatory, logical address
>      "--length LENGTH"
>         Optional, default to sectorsize of the fs
>      "--mirror"
>         Optional, default to all mirror
>
--mirror  option  Is this referring to file-data alone?. If so,
including an option to target meta-data from specific mirror will be
helpful.

For example:
Setup: RAID-1 with 3 drives (both data/meta-data mirrored)
Corrupt an inode from drive-2.
Running Btrfs-check figures out drive-1,drive-3 are valid entries and
updates/fixes drive-2 entries.

Something like that possible or i miss understood something?


Cheers.
Lakshmipathi.G
