Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:34845 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751385AbcHTGCf (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 20 Aug 2016 02:02:35 -0400
Received: by mail-lf0-f45.google.com with SMTP id f93so45817777lfi.2
        for <linux-btrfs@vger.kernel.org>; Fri, 19 Aug 2016 23:02:34 -0700 (PDT)
Subject: Re: Mixing partitioned and non-partitioned discs in a RAID?
To: =?UTF-8?Q?Bearcat_=c5=9e=c3=a1ndor?= <bearcatsandor@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CAMPo9spd+GF18K7sDZDsfvqLQJYwt_YuYM_05KOnVFmw_Vsrhw@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <1690ed69-15d1-6a22-b52c-8060fe77759a@gmail.com>
Date: Sat, 20 Aug 2016 09:02:31 +0300
MIME-Version: 1.0
In-Reply-To: <CAMPo9spd+GF18K7sDZDsfvqLQJYwt_YuYM_05KOnVFmw_Vsrhw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

20.08.2016 07:00, Bearcat Şándor пишет:
> I have a btrfs non-raid file system that i'd like to convert to
> raid10. This single device has my efi boot partion on it, so it's
> partitioned into sda1 and sda2. I have 3 other discs (sdc-sde) that
> i'd like to make partition-less systems and then add them to the first
> disc (sda) using the steps in the conversion section of the wiki
> (https://btrfs.wiki.kernel.org/index.php/Using_Btrfs_with_Multiple_Devices#Conversion).
> 
> My concern in that i'll be mixing a partitioned and partition-less
> system.  Will that work or will i hose myself?
> 
Assuming all disks are of equal size, you will lose space on
non-partitioned disks which is at least equal to your EFI boot
partition. So it does not offer any advantages; in general the more
uniform configuration, the better.

