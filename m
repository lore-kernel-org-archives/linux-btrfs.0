Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48529 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757378AbcALA1m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Jan 2016 19:27:42 -0500
Subject: Re: [PATCH] btrfs-progs: chunk-recovery: Fix a float point error
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.com>
References: <1447915359-29707-1-git-send-email-quwenruo@cn.fujitsu.com>
 <5693102C.609@cn.fujitsu.com> <20160111091438.GF4227@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <5694486C.8040001@cn.fujitsu.com>
Date: Tue, 12 Jan 2016 08:27:24 +0800
MIME-Version: 1.0
In-Reply-To: <20160111091438.GF4227@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, I meant 4.4.

And thank you for merging it.

Thanks,
Qu

David Sterba wrote on 2016/01/11 10:14 +0100:
> On Mon, Jan 11, 2016 at 10:15:08AM +0800, Qu Wenruo wrote:
>> Hi David,
>>
>> Would you please consider merging this patch for v4.2 btrfs-progs?
>
> Do you really mean 4.2? The patch is queued for 4.4 release,
> commit a99d13dccee11d29da3d045c2c2fc69d47eff770
>
>


