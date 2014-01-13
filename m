Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:29154 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbaAMHM0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 02:12:26 -0500
Message-ID: <52D39199.7050401@cn.fujitsu.com>
Date: Mon, 13 Jan 2014 15:11:21 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Remco Hosman - Yerf IT <remco@yerf-it.nl>
CC: linux-btrfs@vger.kernel.org
Subject: Re: ENOSPC during balance
References: <97A7F0AC-8A96-4BFA-A6C0-DD878629FCF2@yerf-it.nl>
In-Reply-To: <97A7F0AC-8A96-4BFA-A6C0-DD878629FCF2@yerf-it.nl>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/12/2014 10:49 PM, Remco Hosman - Yerf IT wrote:
> HI,
>
> I am trying to convert my array from raid10 to 1, and its partially completed, but at the moment i am getting a '59366.459092] btrfs: 185 enospc errors during balance’ when i try to balance anything more with `btrfs bal start -dconvert=raid1,soft /mountpoint`
>
> I have already scanned for files with extends over 1gig gig, and there is at least 100gig unallocated on each of the disks, and scrub reports no error at all.
> Kernel is 3.13-rc7 and tools are latest from git.
>
> Anything else i can try ?
Hi Remco,

Not very sure if i can help you,  but i think you can try to defrag your 
btrfs filesystem firstly,
which might give our enough continuous free space.^_^

Thanks,
Wang
>
> Thanks,
> Remco--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

