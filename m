Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:35971 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdI3N1R (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 09:27:17 -0400
Received: from localhost (unknown [192.168.1.197])
        by mail.linuxsystems.it (Postfix) with ESMTPSA id 35611B4108
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Sep 2017 15:27:14 +0200 (CEST)
From: =?iso-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
To: <linux-btrfs@vger.kernel.org>
Subject: Re: Cannot fix btrfs errors after system crash
Date: Sat, 30 Sep 2017 15:27:03 +0200
MIME-Version: 1.0
Message-ID: <09e49943-229e-4daa-bfaa-380a26f868a1@linuxsystems.it>
In-Reply-To: <67acfe4b-e08b-44a2-8f1f-52676b1654b7@linuxsystems.it>
References: <67acfe4b-e08b-44a2-8f1f-52676b1654b7@linuxsystems.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I decided I wanted to try if letting btrfs manipulate those extens would 
have fixed my issue. So I launched a full balance followed by a 
deduplication followed by another full balance. Then I checked the fs once 
again: everything got fixed during the data manipulation.
Anyway btrfs check --repair should be able to fix such things without the 
need for such tricks, so I hope it will get fixed one day.

Bests,
Niccolò

Il mercoledì 27 settembre 2017 23:47:04 CEST, Niccolò Belli ha scritto:
> Hi,
> I was trying to use AMDGPU-PRO's OpenCL stack (with the 
> mainline 4.12.13 kernel) while it suddently crashed the whole 
> system, not even magic sysrq keys did work anymore.
> With no surprise, at the next reboot I found several btrfs 
> warnings (see 
> https://paste.pound-python.org/show/S5zBG2tXZUTLG699saE5/).
> Since btrfs scrub didn't find any error I decided to reboot 
> into a live usb and start a btrfs check (I'm using btrfs-progs 
> 4.13).
> It did found lots of errors indeed (see 
> https://paste.pound-python.org/show/IPxh9sly0EEb0MKPi2dw/).
> So I made a full backup with dd and I started a btrfs check 
> --repair (see 
> https://paste.pound-python.org/show/c9AlT8ehKKJy6l5xhzXk/).
> I also wiped the space cache with --clear-space-cache v1.
> A subsequent btrfs check revealed it indeed fixed lots of 
> errors (see 
> https://paste.pound-python.org/show/1m2Wodd1q3n0eRlxLpZB/), but 
> unfortunately i still have the following errors:
>
> unresolved ref dir 7450239 index 2 namelen 6 name 431886 
> filetype 1 errors 80, filetype mismatch
> unresolved ref dir 7450595 index 2 namelen 6 name 431886 
> filetype 1 errors 80, filetype mismatch
> unresolved ref dir 7457122 index 2 namelen 6 name 431886 
> filetype 1 errors 80, filetype mismatch
>
> I'm already quite satisfied to be honest: two years ago repair 
> used to eat my data, making things worse.
> Anyway, why didn't btrfs-check repair them? Is there anything I 
> can do to fix them?
>
> Thanks,
> Niccolò
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

