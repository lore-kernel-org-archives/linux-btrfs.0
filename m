Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50859 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757434AbaIRG0V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Sep 2014 02:26:21 -0400
Message-ID: <541A7B0B.4010503@cn.fujitsu.com>
Date: Thu, 18 Sep 2014 14:26:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] <subvol> doesn't belong to btrfs mount point
References: <1E99F2EE-0D94-4271-990F-3535BB005A0A@colorremedies.com> <D8984BA0-E220-4D74-AADC-5C488023EDA1@colorremedies.com>
In-Reply-To: <D8984BA0-E220-4D74-AADC-5C488023EDA1@colorremedies.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am very sorry that my commit caused the problem.

In fact some users have already find the problem and I sent the fix some 
time ago.

The patch is https://patchwork.kernel.org/patch/4842201/

Hopes this helps.

Thanks,
Qu
-------- Original Message --------
Subject: Re: [bug] <subvol> doesn't belong to btrfs mount point
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Date: 2014年09月16日 10:08
> On Sep 12, 2014, at 5:39 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
>> Summary: When a btrfs subvolume is mounted with -o subvol, and a nested ro subvol/snapshot is created, btrfs send returns with an error. If the top level (id 5) is mounted instead, the send command succeeds.
> I'm not able to reproduce this, so at the moment I'm going to say it's user error until I can.
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

