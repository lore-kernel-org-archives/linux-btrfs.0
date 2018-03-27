Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:37976 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751489AbeC0DnI (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Mar 2018 23:43:08 -0400
Subject: Re: Corruption on Big Endian System
To: Ashu Tiwary <ashuatibm@gmail.com>, linux-btrfs@vger.kernel.org
References: <CACJ+inTx=1tfrx0V-2gwq08xxMxvzCq7oBPGcPnH8xUhtX4uBQ@mail.gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <ed992fdc-4e66-872f-33f0-f28043c9dc37@oracle.com>
Date: Tue, 27 Mar 2018 11:45:00 +0800
MIME-Version: 1.0
In-Reply-To: <CACJ+inTx=1tfrx0V-2gwq08xxMxvzCq7oBPGcPnH8xUhtX4uBQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




On 03/26/2018 11:00 PM, Ashu Tiwary wrote:
> It appears my system may have hit the issue reverted here (
> https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg74621.html
> ) ( [PATCH] Revert "btrfs: use proper endianness accessors for
> super_copy" ); system is an IBM OpenPower 720 (Big Endian) running
> Fedora 27; kernel was at 4.15.9; attempting to reboot after updating
> system (including kernel to 4.15.10) caused system to not be able to
> boot:

  Sorry for the inconvenience. Can you please provide:
    btrfs in dump-super -af <dev>

  David has a tool to fix it. I can't find in his github. David?

Thanks, Anand

> =====
>           Mounting /sysroot...
> [   34.644721] BTRFS warning (device dm-3): suspicious: generation <
> chunk_root_generation: 15959351903540740096 < 17261735521269317632
> [   34.644761] BTRFS info (device dm-3): disk space caching is enabled
> [   34.644771] BTRFS info (device dm-3): has skinny extents
> [   34.645925] BTRFS critical (device dm-3): unable to find logical
> 71472550772736 length 65536
> [   34.645941] BTRFS critical (device dm-3): unable to find logical
> 71472550772736 length 65536
> [   34.645952] BTRFS error (device dm-3): failed to read chunk root
> [   34.807156] BTRFS error (device dm-3): open_ctree failed
> [FAILED] Failed to mount /sysroot.
> =====
> 
> It appears there is a manual method available to repair the corrupted
> superblock: can that be made available?
> 
> Thanks,
> 
> -Ashu
> 
> --
> Ashu Tiwary
> ashuatibm@gmail.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
