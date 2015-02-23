Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:22746 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751568AbbBWBvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 22 Feb 2015 20:51:19 -0500
Message-ID: <54EA8798.4090302@cn.fujitsu.com>
Date: Mon, 23 Feb 2015 09:51:20 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: =?UTF-8?B?Sm9oYW4gS3LDtmNrZWw=?= <johan.kroeckel@gmail.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: create subvolume defining id
References: <CABgvyo8MFfV+CGeeHcwBfnVkSKQ5jbkL9RFr3S=oRR_np0GbDA@mail.gmail.com>
In-Reply-To: <CABgvyo8MFfV+CGeeHcwBfnVkSKQ5jbkL9RFr3S=oRR_np0GbDA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: create subvolume defining id
From: Johan Kröckel <johan.kroeckel@gmail.com>
To: <linux-btrfs@vger.kernel.org>
Date: 2015年02月19日 19:11
> Is it possible to create a subvolume and define the id?
What do you mean by the word "id"?

Did you mean subvolid or something else?

If you mean subvolid, IIRC struct btrfs_ioctl_vol_args_v2 doesn't have 
the member to record the subvolid,
which means without some changes in btrfs-progs and kernel, it won't be 
possible.

BTW, why you need to use subvolid, it's not so human-friendly than the 
path name.

Thanks,
Qu
>   
>
> Like "btrfs subvolume create TEST id=9999"?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

