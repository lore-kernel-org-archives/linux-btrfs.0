Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23488 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751499AbcHaBBF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 Aug 2016 21:01:05 -0400
Subject: Re: [PATCH] btrfs-progs: fuzz-test: Add image for wrong chunk item in
 root tree
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        Lukas Lueg <lukas.lueg@gmail.com>
References: <20160830021550.11502-1-quwenruo@cn.fujitsu.com>
 <20160830141751.GF16983@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a8d747e5-fb69-a08a-e03b-ab3eec528252@cn.fujitsu.com>
Date: Wed, 31 Aug 2016 09:01:00 +0800
MIME-Version: 1.0
In-Reply-To: <20160830141751.GF16983@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 08/30/2016 10:17 PM, David Sterba wrote:
> On Tue, Aug 30, 2016 at 10:15:50AM +0800, Qu Wenruo wrote:
>> From: Lukas Lueg <lukas.lueg@gmail.com>
>>
>> Reported by Lukas and the same image from him.
>>
>> DATA_RELOC tree's key type is modifed to CHUNK_ITEM, causing btrfsck
>> interpret it as CHUNK_ITEM and cause 0 num_stripes.
>>
>> Add the image to fuzz-test.
>>
>> Signed-off-by: Lukas Lueg <lukas.lueg@gmail.com>
>
> BTW I think you should put Reported-by here, that's the reporter's
> credit. The signed-off from you is for your contribution to the git
> repository (packing the image, documenting the origin etc). I've fixed
> that in the commit.
>
>
Thanks for the fix.

I'll keep this in mind.

Thanks,
Qu


