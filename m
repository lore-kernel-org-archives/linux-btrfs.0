Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f174.google.com ([209.85.217.174]:33293 "EHLO
        mail-ua0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751569AbdHQAXh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 16 Aug 2017 20:23:37 -0400
Received: by mail-ua0-f174.google.com with SMTP id r9so10331807uad.0
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Aug 2017 17:23:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170816092734.GN19638@pontus.sran>
References: <20170814225740.GK19638@pontus.sran> <CAJCQCtR6CXOC+veFEWoC1aC+BvKgwpnAZ_ZsA2acuLRNwybkTw@mail.gmail.com>
 <20170816092734.GN19638@pontus.sran>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 16 Aug 2017 18:23:36 -0600
Message-ID: <CAJCQCtQQnZDiFJi7mD1p7VwuftFGfCJcWFFNqiSAT8eAChwEag@mail.gmail.com>
Subject: Re: btrfs fi du -s gives Inappropriate ioctl for device
To: Piotr Szymaniak <szarpaj@grubelek.pl>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 16, 2017 at 3:27 AM, Piotr Szymaniak <szarpaj@grubelek.pl> wrote:
> On Mon, Aug 14, 2017 at 05:40:30PM -0600, Chris Murphy wrote:
>> On Mon, Aug 14, 2017 at 4:57 PM, Piotr Szymaniak <szarpaj@grubelek.pl> wrote:
>>
>> >
>> > and... some issues:
>> > ~ # btrfs fi du -s /mnt/red/\@backup/
>> >      Total   Exclusive  Set shared  Filename
>> > ERROR: cannot check space of '/mnt/red/@backup/': Inappropriate ioctl for device
>>
>>
>> It's a bug, but I don't know if any devs are working on a fix yet.
>>
>> The problem is that the subvolume being snapshot, contains subvolumes.
>> The resulting snapshot, contains an empty directory in place of the
>> nested subvolume(s), and that is the cause for the error.
>
> Ok, but why, on the same btrfs, it works on some subvols with subvols and does
> not work on other subvols with subvols? If it does not work - OK, if it works -
> OK, but that seems a bit... random?
>
> ~ # btrfs fi du -s /mnt/red/\@backup/ /mnt/red/\@backup/.snapshot/monthly_2017-08-01_05\:30\:01/ /mnt/red/\@svn/ /mnt/red/\@svn/.snapshot/weekly_2017-08-05_04\:20\:02/
>      Total   Exclusive  Set shared  Filename
> ERROR: cannot check space of '/mnt/red/@backup/': Inappropriate ioctl for device
> ERROR: cannot check space of '/mnt/red/@backup/.snapshot/monthly_2017-08-01_05:30:01/': Inappropriate ioctl for device
>   52.23GiB    10.57MiB     4.13GiB  /mnt/red/@svn/
>    4.35GiB     1.03MiB     4.12GiB  /mnt/red/@svn/.snapshot/weekly_2017-08-05_04:20:02/

I don't know.

 It might be that there's something inconsistent about the inode for
the missing/ghost subvolume placeholder directory at snapshot creation
time?

-- 
Chris Murphy
