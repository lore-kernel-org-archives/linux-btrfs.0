Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:28800 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751586AbaGUB1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jul 2014 21:27:14 -0400
Message-ID: <53CC6B39.1060705@cn.fujitsu.com>
Date: Mon, 21 Jul 2014 09:22:01 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: TM <tmjuju@yahoo.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: 1 week to rebuid 4x 3TB raid10 is a long time!
References: <loom.20140720T102642-239@post.gmane.org>
In-Reply-To: <loom.20140720T102642-239@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 07/20/2014 04:45 PM, TM wrote:
> Hi,
>
> I have a raid10 with 4x 3TB disks on a microserver
> http://n40l.wikia.com/wiki/Base_Hardware_N54L , 8Gb RAM
>
> Recently one disk started to fail (smart errors), so I replaced it
> Mounted as degraded, added new disk, removed old
> Started yesterday
> I am monitoring /var/log/messages and it seems it will take a long time
> Started at about 8010631739392
> And 20 hours later I am at 6910631739392
> btrfs: relocating block group 6910631739392 flags 65
>
> At this rate it will take a week to complete the raid rebuild!!!
Just my two cents:

Since 'btrfs replace' support RADI10, I suppose using replace
operation is better than 'device removal and add'.

Another Question is related to btrfs snapshot-aware balance.
How many snapshots did you have in your system?

Of course, During balance/resize/device removal operations,
you could still snapshot, but fewer snapshots should speed things up!

Anyway 'btrfs replace' is implemented more effective than
'device remova and add'.:-)

Thanks,
Wang
>
> Furthermore it seems that the operation is getting slower and slower
> When the rebuild started I had a new message every half a minute, now it’s
> getting to OneAndHalf minutes
> Most files are small files like flac/jpeg
>
> One week for a raid10 rebuild 4x3TB drives is a very long time.
> Any thoughts?
> Can you share any statistics from your RAID10 rebuilds?
>
> If I shut down the system, before the rebuild, what is the proper procedure
> to remount it? Again degraded? Or normally? Can the process of rebuilding
> the raid continue after a reboot? Will it survive, and continue rebuilding?
>
> Thanks in advance
> TM
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

