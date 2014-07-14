Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:47696 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbaGNToz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Jul 2014 15:44:55 -0400
Received: by mail-qc0-f172.google.com with SMTP id l6so4009757qcy.17
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Jul 2014 12:44:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53BF74ED.5010407@cn.fujitsu.com>
References: <CAMXuLLoeHPkX+Ym9a-HjVv=5ccqx9wo9tkbMLsySmgC=YJxgZQ@mail.gmail.com>
	<53BF74ED.5010407@cn.fujitsu.com>
Date: Mon, 14 Jul 2014 15:44:54 -0400
Message-ID: <CAMXuLLq8m8A1NrHEhT1j8X8-ScFNv0cGu8u-Mggawn-jNCiH+Q@mail.gmail.com>
Subject: Re: [Question] disk_bytenr with multiple devices
From: Zhe Zhang <zhe.zhang.research@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks Qu. I followed the wiki and your advice and finally got it working.

BTW I created a program printing the disk block addresses of a file.
URL here if anyone else finds it a useful feature:
https://github.com/oldcap/btrfs-progs/blob/master/btrfs-file-blocks.c

On Fri, Jul 11, 2014 at 1:23 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>
> -------- Original Message --------
> Subject: [Question] disk_bytenr with multiple devices
> From: Zhe Zhang <zhe.zhang.research@gmail.com>
> To: linux-btrfs@vger.kernel.org
> Date: 2014年07月11日 02:21
>>
>> When a btrfs has multiple devices (e.g. /dev/sdb, /dev/sdc), how
>> should I interpret disk_bytenr in btrfs_file_extent_item?
>>
>> Does it depend on the striping config? Say I used raid0, then
>> disk_bytenr 0~64K will be on /dev/sdb, and 64K~128K on /dev/sdc?
>>
>> Thanks,
>> Zhe
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> https://btrfs.wiki.kernel.org/index.php/Data_Structures#btrfs_file_extent_item
> As you can see in the btrfs wiki,
> disk_bytenr is *logical* address in btrfs linear space. Not really on disk
> address.
>
> If you really want the address on device, you need to find the chunk
> containing the address,
> then the stripe in chunk item will show the raid profile and device address
> on each device.
>
> Thanks,
> Qu
