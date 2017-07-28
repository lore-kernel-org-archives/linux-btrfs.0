Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lmr1.uibk.ac.at ([138.232.1.142]:46416 "EHLO lmr1.uibk.ac.at"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752488AbdG1Th2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 15:37:28 -0400
Received: from [10.0.0.8] (193-83-34-21.adsl.highway.telekom.at [193.83.34.21])
        (authenticated bits=0)
        by smtp.uibk.ac.at (8.14.4/8.14.4/F1) with ESMTP id v6SJWIqV004054
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2017 21:32:26 +0200
Subject: Re: Btrfs incremental send | receive fails with Error: File not found
To: linux-btrfs@vger.kernel.org
References: <59b8cc62-66fa-6665-45f9-89c6fe91ceaa@gmail.com>
From: =?UTF-8?Q?Hermann_Schw=c3=a4rzler?=
        <hermann.schwaerzler@freirad.at>
Message-ID: <403536b6-2404-8589-3536-3a91ae769cd6@freirad.at>
Date: Fri, 28 Jul 2017 21:32:18 +0200
MIME-Version: 1.0
In-Reply-To: <59b8cc62-66fa-6665-45f9-89c6fe91ceaa@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

for me it looks like those snapshots are not read-only. But as far as I 
know for using send they have to be.

At least
https://btrfs.wiki.kernel.org/index.php/Incremental_Backup#Initial_Bootstrapping
states "We will need to create a read-only snapshot ,,,"

I am using send/receive (with read-only snapshots) on a regular basis 
and never had a problem like yours.

What are the commands you use to create your snapshots?

Greetings
Hermann

On 07/28/2017 07:26 PM, A L wrote:
> I often hit the following error when doing incremental btrfs send-receive:
> Btrfs incremental send | receive fails with Error: File not found
>
> Sometimes I can do two-three incremental snapshots, but then the same
> error (different file) happens again. It seems that the files were
> changed or replaced between snapshots, which is causing the problems for
> send-receive. I have tried to delete all snapshots and started over but
> the problem comes back, so I think it must be a bug.
>
> The source volume is:   /mnt/storagePool (with RAID1 profile)
> with subvolume:   volume/userData
> Backup disk is:   /media/usb-backup (external USB disk)
[...]

