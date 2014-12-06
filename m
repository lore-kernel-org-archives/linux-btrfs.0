Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:63752 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaLFE5a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 5 Dec 2014 23:57:30 -0500
Received: by mail-yk0-f178.google.com with SMTP id 20so905615yks.37
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Dec 2014 20:57:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <88e897a70d1ac64a5b6b2c4b2e9e49d5@admin.virtall.com>
References: <3146bf116f41e590e8ce4fdb610def31@admin.virtall.com>
	<CAJCQCtRh7HU9yd-pxgXzXebVcjukQh6Lyhzfcd6bBJppyCxChQ@mail.gmail.com>
	<88e897a70d1ac64a5b6b2c4b2e9e49d5@admin.virtall.com>
Date: Fri, 5 Dec 2014 21:57:29 -0700
Message-ID: <CAJCQCtSGy5MBVC4hQUgHBtSy+6kNOap_0Mfb7f9G4HJH9AmtUQ@mail.gmail.com>
Subject: Re: btrfs device delete missing - Input/output error
From: Chris Murphy <lists@colorremedies.com>
To: Tomasz Chmielewski <tch@virtall.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 5, 2014 at 10:28 AM, Tomasz Chmielewski <tch@virtall.com> wrote:
> On 2014-12-05 17:41, Chris Murphy wrote:
>
>> You're getting a read error when writing. This is expected when
>> writing 512 bytes to a 4k sector.
>>
>> What do you get for
>>  parted /dev/sdb u s p
>
>
> Right - so we're getting these:
>
> # parted /dev/sdb u s p
> Model: ATA ST3000DM001-9YN1 (scsi)
> Disk /dev/sdb: 5860533168s
> Sector size (logical/physical): 512B/4096B

OK it's a 4096 byte physical sector drive so you have to use the
bs=4096 command with the proper seek value (which is based on the bs
value).



-- 
Chris Murphy
