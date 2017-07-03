Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:36612 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750783AbdGCEOn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Jul 2017 00:14:43 -0400
Received: by mail-ua0-f179.google.com with SMTP id g40so102386898uaa.3
        for <linux-btrfs@vger.kernel.org>; Sun, 02 Jul 2017 21:14:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAKuJGC-p49NKDzjOoPUODQ6t8JSN_R39Mij_G2OEcmENwN9Q8w@mail.gmail.com>
References: <CAKuJGC-p49NKDzjOoPUODQ6t8JSN_R39Mij_G2OEcmENwN9Q8w@mail.gmail.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Mon, 3 Jul 2017 09:44:02 +0530
Message-ID: <CAKuJGC9RpLNeCvHaAXx8=104rkACu8B5uyaLoZ+ZWU6fOxZwVg@mail.gmail.com>
Subject: Re: btrfs-convert --no-datasum & btrfs check: check_owner_ref: BUG_ON
 `rec->is_root` triggered, value 1
To: btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Looked like I missed few patch.  After checking with latest branch. Its working.

----
Cheers,
Lakshmipathi.G



On Sun, Jul 2, 2017 at 7:30 PM, Lakshmipathi.G <lakshmipathi.g@gmail.com> wrote:
> Hi.
> While using btrfs-convert with '--no-datasum' option & running btrfs
> check crashes:
>
> steps:
> mkfs.ext4 tests/t1
> mount tests/t1 /data
> cp -r *.c /data
> umount /data
> ./btrfs-convert --no-datasum tests/t1
> ./btrfs check tests/t1
> <crash>
> cmds-check.c:5488: check_owner_ref: BUG_ON `rec->is_root` triggered, value 1
>
> Is this a bug or something wrong with my environment?
>
> More info: https://bugzilla.kernel.org/show_bug.cgi?id=196217
> ----
> Cheers,
> Lakshmipathi.G
