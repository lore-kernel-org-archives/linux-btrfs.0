Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f48.google.com ([209.85.215.48]:34992 "EHLO
        mail-lf0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753060AbdG1X0q (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 28 Jul 2017 19:26:46 -0400
Received: by mail-lf0-f48.google.com with SMTP id t128so66626884lff.2
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Jul 2017 16:26:46 -0700 (PDT)
Subject: Re: Btrfs incremental send | receive fails with Error: File not found
To: linux-btrfs@vger.kernel.org
References: <59b8cc62-66fa-6665-45f9-89c6fe91ceaa@gmail.com>
 <403536b6-2404-8589-3536-3a91ae769cd6@freirad.at>
Cc: =?UTF-8?Q?Hermann_Schw=c3=a4rzler?=
        <hermann.schwaerzler@freirad.at>
From: A L <crimsoncottage@gmail.com>
Message-ID: <c64a25d7-3845-e51a-c9b1-85de5190aceb@gmail.com>
Date: Sat, 29 Jul 2017 01:26:43 +0200
MIME-Version: 1.0
In-Reply-To: <403536b6-2404-8589-3536-3a91ae769cd6@freirad.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 7/28/2017 9:32 PM, Hermann Schwärzler wrote:
> Hi
>
> for me it looks like those snapshots are not read-only. But as far as 
> I know for using send they have to be.

They are read-only.
# btrfs property get userData.20170727T1222/
ro=true

>
> At least
> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup#Initial_Bootstrapping 
>
> states "We will need to create a read-only snapshot ,,,"
>
> I am using send/receive (with read-only snapshots) on a regular basis 
> and never had a problem like yours.
I have no good explanation. There are no problems reported on the 
filesystems with Btrfs scrub or Btrfs check. Did you also replace files 
with same name between snapshots?
>
> What are the commands you use to create your snapshots?
I used to do it in an hourly cron job like this.
# btrfs subvolume snapshot -r /mnt/storagePool/volume/userData/ 
/mnt/storagePool/snapshots/userData.`date +%Y.%m.%d-%H.%M.%S`
Now I use btrbk, but the command is the same and the problem is the same.

The problem I see seems similar to the issue fixed in 
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f59627810e18d4435051d982b5d05cab18c6e653 
but that commit should already be in kernel-4.13_rc2

>
> Greetings
> Hermann
>
> On 07/28/2017 07:26 PM, A L wrote:
>> I often hit the following error when doing incremental btrfs 
>> send-receive:
>> Btrfs incremental send | receive fails with Error: File not found
>>
>> Sometimes I can do two-three incremental snapshots, but then the same
>> error (different file) happens again. It seems that the files were
>> changed or replaced between snapshots, which is causing the problems for
>> send-receive. I have tried to delete all snapshots and started over but
>> the problem comes back, so I think it must be a bug.
>>
>> The source volume is:   /mnt/storagePool (with RAID1 profile)
>> with subvolume:   volume/userData
>> Backup disk is:   /media/usb-backup (external USB disk)
> [...]
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
