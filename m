Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:35359 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751507AbaARFbS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 18 Jan 2014 00:31:18 -0500
Message-ID: <52DA1160.50504@cn.fujitsu.com>
Date: Sat, 18 Jan 2014 13:30:08 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: "linux-btrfs@vger.kernel.org Btrfs" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs-progs: make send/receive compatible with older
 kernels
References: <1389264758-9495-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <52CE8CDC.6030408@giantdisaster.de> <20140109121606.GI15634@carfax.org.uk> <1389279172.23310.50.camel@ret.masoncoding.com> <20140114152756.GX6498@twin.jikos.cz>
In-Reply-To: <20140114152756.GX6498@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Dave,

On 01/14/2014 11:27 PM, David Sterba wrote:
> On Thu, Jan 09, 2014 at 02:52:27PM +0000, Chris Mason wrote:
>>>     You may need to upgrade the kernel to get new features offered by a
>>> new userspace, but I think we should absolutely not be changing
>>> userspace in a way that makes it incompatible with older kernels.
>> I'd really prefer that we maintain compatibility with the older kernels.
>> Heavy btrfs usage is going to want a newer kernel anyway, but this is an
>> important policy to keep in place for the future.
> I agree.
>
>> Especially since Wang went to the trouble of making the patch, I'd
>> rather take it.
> What do you think about adding #ifdef's around the code? That way we'll
> know that's for backwards compatibility only and up to what kernel
> version. It will be easier to remove it in the far future.
Sounds a good idea, would you describe it more specific so that
i can give a v2.^_^

Thanks，
Wang
>
>
> david
>

