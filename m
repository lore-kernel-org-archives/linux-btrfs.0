Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:33477 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751844AbeAOA6Q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 Jan 2018 19:58:16 -0500
Received: by mail-pg0-f46.google.com with SMTP id i196so7249510pgd.0
        for <linux-btrfs@vger.kernel.org>; Sun, 14 Jan 2018 16:58:16 -0800 (PST)
Received: from sharpeth.aviatis.com (107-215-1-140.lightspeed.sntcca.sbcglobal.net. [107.215.1.140])
        by smtp.gmail.com with ESMTPSA id q65sm42063278pfj.137.2018.01.14.16.58.14
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 14 Jan 2018 16:58:14 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: Hanging after frequent use of systemd-nspawn --ephemeral
From: Johannes Ernst <johannes.ernst@gmail.com>
In-Reply-To: <d507460e-5a91-4129-3cd2-b270ab73c8b5@gmx.com>
Date: Sun, 14 Jan 2018 16:58:13 -0800
Message-Id: <C376D549-BE55-4B02-A681-39180F63E372@gmail.com>
References: <6B7B9360-41EA-4190-8C7D-9E001D186B23@gmail.com> <8c9933e1-f694-a513-83ca-33fcb503b7e8@gmx.com> <AA437C7B-EB91-46F7-BE01-2254A20DB75E@gmail.com> <d507460e-5a91-4129-3cd2-b270ab73c8b5@gmx.com>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> INFO: task systemd-journal:20876 blocked for more than 120 seconds.
>> [ 5037.962603]       Tainted: G         C O    4.14.9-1-ARCH #1
>> [ 5037.962609] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>> [ 5037.962616] systemd-journal D    0 20876  20860 0x00000100
>> [ 5037.962622] Call Trace:
>> [ 5037.962635]  ? __schedule+0x290/0x890
>> [ 5037.962640]  ? __slab_free+0x14e/0x300
>> [ 5037.962645]  ? _copy_to_iter+0x8f/0x3d0
>> [ 5037.962651]  schedule+0x2f/0x90
>> [ 5037.962704]  btrfs_tree_read_lock+0xb6/0x100 [btrfs]
> 
> Still some tree write is blocking all incoming read.
> 
> BTW, did your tests include any send and relocation operations?
> 
> IIRC there is a bug that makes send and relocation (I'm not sure though)
> will cause similar problem.

No. I’m doing nothing btrfs-specific at all, it’s just whatever systemd-nspawn —ephemeral does.

Cheers,



Johannes.