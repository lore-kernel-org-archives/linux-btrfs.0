Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:45974 "EHLO
        mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753340AbeAOBrW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 20:47:22 -0500
Received: by mail-pf0-f176.google.com with SMTP id a88so5830317pfe.12
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jan 2018 17:47:22 -0800 (PST)
Received: from sharpeth.aviatis.com (107-215-1-140.lightspeed.sntcca.sbcglobal.net. [107.215.1.140])
        by smtp.gmail.com with ESMTPSA id o69sm4527227pfj.32.2018.01.14.17.47.20
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 14 Jan 2018 17:47:20 -0800 (PST)
From: Johannes Ernst <johannes.ernst@gmail.com>
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: Hanging after frequent use of systemd-nspawn --ephemeral
In-Reply-To: <618575b8-419e-3d09-add0-e42d2c0bb7b2@gmx.com>
Date: Sun, 14 Jan 2018 17:47:19 -0800
Message-Id: <A1CD808B-DBAD-47E7-BE50-B376021C27FB@gmail.com>
References: <6B7B9360-41EA-4190-8C7D-9E001D186B23@gmail.com> <8c9933e1-f694-a513-83ca-33fcb503b7e8@gmx.com> <AA437C7B-EB91-46F7-BE01-2254A20DB75E@gmail.com> <d507460e-5a91-4129-3cd2-b270ab73c8b5@gmx.com> <C376D549-BE55-4B02-A681-39180F63E372@gmail.com> <618575b8-419e-3d09-add0-e42d2c0bb7b2@gmx.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>>>> INFO: task systemd-journal:20876 blocked for more than 120 seconds.
>>>> [ 5037.962603]       Tainted: G         C O    4.14.9-1-ARCH #1
>>>> [ 5037.962609] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>>> [ 5037.962616] systemd-journal D    0 20876  20860 0x00000100
>>>> [ 5037.962622] Call Trace:
>>>> [ 5037.962635]  ? __schedule+0x290/0x890
>>>> [ 5037.962640]  ? __slab_free+0x14e/0x300
>>>> [ 5037.962645]  ? _copy_to_iter+0x8f/0x3d0
>>>> [ 5037.962651]  schedule+0x2f/0x90
>>>> [ 5037.962704]  btrfs_tree_read_lock+0xb6/0x100 [btrfs]
>>> 
>>> Still some tree write is blocking all incoming read.
>>> 
>>> BTW, did your tests include any send and relocation operations?
>>> 
>>> IIRC there is a bug that makes send and relocation (I'm not sure though)
>>> will cause similar problem.
>> 
>> No. I’m doing nothing btrfs-specific at all, it’s just whatever systemd-nspawn —ephemeral does.
> 
> So, only systemd-nspwan --ephemeral, and nothing else at all?
> 
> Even nothing happened inside the container?


Gotcha. (Sorry for missing that)

Inside the container, snapper might be invoked. Here are the snippets:

snapper -c root create-config -t ubos-default /
snapper setup-quota
snapper -c root create --type pre --print-number
snapper -c root create --type post --pre-number <n>

Here is the snapper config:

# Snapper default configuration for UBOS.
#
# subvolume to snapshot
SUBVOLUME="/"

# filesystem type
FSTYPE="btrfs"

# btrfs qgroup for space aware cleanup algorithms
QGROUP=""

# fraction of the filesystems space the snapshots may use
SPACE_LIMIT="0.2"

# users and groups allowed to work with config
ALLOW_USERS=""
ALLOW_GROUPS=""

# sync users and groups from ALLOW_USERS and ALLOW_GROUPS to .snapshots
# directory
SYNC_ACL="no"

# start comparing pre- and post-snapshot in background after creating
# post-snapshot
BACKGROUND_COMPARISON="no"

# run daily number cleanup
NUMBER_CLEANUP="yes"

# limit for number cleanup; unit is seconds
NUMBER_MIN_AGE="1800"
NUMBER_LIMIT="50"
NUMBER_LIMIT_IMPORTANT="10"

# create hourly snapshots
TIMELINE_CREATE="no"

# cleanup hourly snapshots after some time
TIMELINE_CLEANUP="yes"

# limits for timeline cleanup; unit is seconds
TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="12"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="6"
TIMELINE_LIMIT_YEARLY="0"

# cleanup empty pre-post-pairs
EMPTY_PRE_POST_CLEANUP="yes"

# limits for empty pre-post-pair cleanup
EMPTY_PRE_POST_MIN_AGE="1800"





