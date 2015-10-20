Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62856 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750787AbbJTDzG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 23:55:06 -0400
Subject: Re: Non-RAID1 areas in RAID1, data 8MB, Metadata 8MB, System 4MB
To: james harvey <jamespharvey20@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <CA+X5Wn7d3PLLn0qO9DeN4uWHsD3pnWprjD1BsVqw0pmq4gYKAw@mail.gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5625BB16.8050303@cn.fujitsu.com>
Date: Tue, 20 Oct 2015 11:55:02 +0800
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn7d3PLLn0qO9DeN4uWHsD3pnWprjD1BsVqw0pmq4gYKAw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



james harvey wrote on 2015/10/19 23:49 -0400:
> The create RAID1 example illustrates my question, at:
>
> https://btrfs.wiki.kernel.org/index.php/UseCases#How_do_I_create_a_RAID1_mirror_in_Btrfs.3F
>
> It shows:
>
> mkfs.btrfs -m raid1 -d raid1 /dev/sda1 /dev/sdb1
>
> will result in:
>
> btrfs fi df /mount
>
> Data, RAID1: total=1.00GB, used=128.00KB
> Data: total=8.00MB, used=0.00
> System, RAID1: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=1.00GB, used=24.00KB
> Metadata: total=8.00MB, used=0.00
>
>
> What's the 8MB, System 4MB, and Metadata 8MB areas that appear not to
> be redundant?
That's the temporary data/metadata/system chunk made at mkfs time.

And since you have RAID1, such temporary chunk will never be used.
You can remove such chunk by a balance.

The behavior should be changed in v4.3 and new mkfs in v4.3 should 
remove temporary chunks automatically.

Thanks,
Qu
>
> I'm seeing these small areas on my own RAID1, but using the example
> for simplicity.
>
> I'm sure it has to be OK those spaces aren't redundant, but I don't
> get what could be there that wouldn't be critical...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
