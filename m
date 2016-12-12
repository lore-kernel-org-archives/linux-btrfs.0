Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35989 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751798AbcLLMOT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 07:14:19 -0500
Received: by mail-io0-f193.google.com with SMTP id b194so21020872ioa.3
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Dec 2016 04:14:18 -0800 (PST)
Subject: Re: btrfs-find-root duration?
To: Markus Binsteiner <makkus@gmail.com>, Xin Zhou <xin.zhou@gmx.com>
References: <CADph71xWQyFca34=K9b-1sSNUCChUnBggvcj1O5NKi8hpQjvfA@mail.gmail.com>
 <trinity-19716973-6bfa-438e-8068-ccb3d257eaad-1481419066346@3capp-mailcom-bs02>
 <CADph71wkR31DEK2RREqcDLm6guP10ZDhBHPtrx6ehswVKOhqAw@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <33976a83-21de-8cc1-8b63-18a5caed9db8@gmail.com>
Date: Mon, 12 Dec 2016 07:14:13 -0500
MIME-Version: 1.0
In-Reply-To: <CADph71wkR31DEK2RREqcDLm6guP10ZDhBHPtrx6ehswVKOhqAw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-12-10 20:42, Markus Binsteiner wrote:
> Hi Xin,
>
> thanks. I did not enable autosnap, and I'm pretty sure Debian didn't
> do it for me either, as I would have seen the subvolumes created by it
> at some stage. Good to know about this feature though, will definitely
> use it next time around.
BTRFS itself has no such feature.  What Xin is probably thinking of is a 
piece of third-party software called 'snapper' that gets installed by 
default on at least SUSE and Ubuntu when using BTRFS, but not on Debian 
because they make no assumptions about individual use-case (and there 
are _lots_ of people (myself included) who absolutely do not want 
automatic snapshotting eating up space on our filesystems behind our 
back).  If you do choose to use snapper, make sure to update the 
settings to fit your needs, as the defaults (at least, the defaults 
upstream and on SUSE) are absolutely brain-dead and will eat your 
filesystem (or at least completely kill it's performance) in a couple of 
months on average.
>
> Cheers,
> Markus
>
> On Sun, Dec 11, 2016 at 2:17 PM, Xin Zhou <xin.zhou@gmx.com> wrote:
>> Hi Markus,
>>
>> Some file system automatically generates snapshot, and create a hidden
>> folder for recovery,
>> if the user accidently deletes some files.
>>
>> It seems btrfs also has a autosnap feature,
>> so if this option has been enabled before deletion,
>> or the volume has been mannually generated snapshots, then probably it might
>> be able to perform fast recover.
>>
>> Regards,
>> Xin
>>
>> Sent: Saturday, December 10, 2016 at 4:12 PM
>> From: "Markus Binsteiner" <makkus@gmail.com>
>> To: linux-btrfs@vger.kernel.org
>> Subject: btrfs-find-root duration?
>> It seems I've accidentally deleted all files in my home directory,
>> which sits in its own btrfs partition (lvm on luks). Now I'm trying to
>> find the roots to be able to use btrfs restore later on.
>>
>> btrfs-find-root seems to be taking ages though. I've run it like so:
>>
>> btrfs-find-root /dev/mapper/think--big-home -o 5 > roots.txt
>>
>> After 16 hours, there is still no output, but it's still running
>> utilizing 100% of one core. Is there any way to gauge how much longer
>> it'll take? Should there have been output already while it's running?
>>
>> When I run it without redirecting stdout, I get:
>>
>> $ btrfs-find-root /dev/mapper/think--big-home -o 5
>>
>> Superblock doesn't contain generation info for root 5
>> Superblock doesn't contain the level info for root 5
>>
>> When I omit the '-o 5', it says:
>>
>> $ btrfs-find-root /dev/mapper/think--big-home
>>
>> Superblock thinks the generation is 593818
>> Superblock thinks the level is 0
>>
>> Is the latter the way to run it? Did that initially, but that didn't
>> return any results in a reasonable timeframe either.
>>
>> The filesystem was created with Debian Jessie, but I'm using Ubuntu (
>> btrfs-progs v4.7.3 ) to try to restore the files at the moment.
>>
>> Thanks!
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

