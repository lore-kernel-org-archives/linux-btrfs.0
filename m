Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:35214 "EHLO
        mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751115AbdHAMyV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 08:54:21 -0400
Received: by mail-lf0-f42.google.com with SMTP id t128so6586470lff.2
        for <linux-btrfs@vger.kernel.org>; Tue, 01 Aug 2017 05:54:20 -0700 (PDT)
Subject: Re: Btrfs incremental send | receive fails with Error: File not found
To: linux-btrfs@vger.kernel.org
References: <59b8cc62-66fa-6665-45f9-89c6fe91ceaa@gmail.com>
 <403536b6-2404-8589-3536-3a91ae769cd6@freirad.at>
Cc: =?UTF-8?Q?Hermann_Schw=c3=a4rzler?=
        <hermann.schwaerzler@freirad.at>
From: A L <crimsoncottage@gmail.com>
Message-ID: <8dc4e2a0-3e83-9e60-c565-c86a924ceaf5@gmail.com>
Date: Tue, 1 Aug 2017 14:54:17 +0200
MIME-Version: 1.0
In-Reply-To: <403536b6-2404-8589-3536-3a91ae769cd6@freirad.at>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK. The problem was that the original subvolume had a "Received UUID". 
This caused all subsequent snapshots to have the same Received UUID 
which messes up Btrfs send | receive. Of course this means I must have 
used btrfs send | receive to create that subvolume and then turned it 
r/w at some point, though I cannot remember ever doing this.

Perhaps a clear notice "WARNING: make sure that the source subvolume 
does not have a Received UUID" on the Wiki would be helpful? Both on 
https://btrfs.wiki.kernel.org/index.php/Incremental_Backup and on 
https://btrfs.wiki.kernel.org/index.php/Manpage/btrfs-property

Regards,
A


On 7/28/2017 9:32 PM, Hermann Schwärzler wrote:
> Hi
>
> for me it looks like those snapshots are not read-only. But as far as 
> I know for using send they have to be.
>
> At least
> https://btrfs.wiki.kernel.org/index.php/Incremental_Backup#Initial_Bootstrapping 
>
> states "We will need to create a read-only snapshot ,,,"
>
> I am using send/receive (with read-only snapshots) on a regular basis 
> and never had a problem like yours.
>
> What are the commands you use to create your snapshots?
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
