Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:37097 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161AbbJROOc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 Oct 2015 10:14:32 -0400
Received: by wicfv8 with SMTP id fv8so45369401wic.0
        for <linux-btrfs@vger.kernel.org>; Sun, 18 Oct 2015 07:14:31 -0700 (PDT)
Received: from [10.0.2.15] (pD9FD55AB.dip0.t-ipconnect.de. [217.253.85.171])
        by smtp.googlemail.com with ESMTPSA id nd9sm11065652wic.0.2015.10.18.07.14.29
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Oct 2015 07:14:30 -0700 (PDT)
From: Philip Seeger <p0h0i0l0i0p@gmail.com>
Subject: Re: "free_raid_bio" crash on RAID6
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <CAGwxe4j7J5ztPk-OyeOuX2YH6SO3G9_h6VU_1wWMdP4rHpqiew@mail.gmail.com>
Message-ID: <5623A943.2030304@googlemail.com>
Date: Sun, 18 Oct 2015 16:14:27 +0200
MIME-Version: 1.0
In-Reply-To: <CAGwxe4j7J5ztPk-OyeOuX2YH6SO3G9_h6VU_1wWMdP4rHpqiew@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Tobias

On 07/20/2015 06:20 PM, Tobias Holst wrote:
> My btrfs-RAID6 seems to be broken again :(
>
> When reading from it I get several of these:
> [  176.349943] BTRFS info (device dm-4): csum failed ino 1287707
> extent 21274957705216 csum 2830458701 wanted 426660650 mirror 2
>
> then followed by a "free_raid_bio"-crash:
>
> [  176.349961] ------------[ cut here ]------------
> [  176.349981] WARNING: CPU: 6 PID: 110 at
> /home/kernel/COD/linux/fs/btrfs/raid56.c:831
> __free_raid_bio+0xfc/0x130 [btrfs]()
> ...

It's been 3 months now, have you ever figured this out? Do you know if 
the bug has been identified and fixed or have you filed a bugzilla report?

> One drive is broken, so at the moment it is mounted with "-O
> defaults,ro,degraded,recovery,compress=lzo,space_cache,subvol=raid".

Did you try removing the bad drive and did the system keep crashing anyway?



Philip
