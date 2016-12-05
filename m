Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14419 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750746AbcLEFH1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Dec 2016 00:07:27 -0500
Subject: Re: btrfs repair and zero-log doesn't seem to do anything
To: Calle Kabo <calle.kabo@gmail.com>, <linux-btrfs@vger.kernel.org>
References: <6dbdc042-6b05-8270-e869-fcf95a99157d@gmail.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a3bad432-968b-83e8-4c35-69e27124107e@cn.fujitsu.com>
Date: Mon, 5 Dec 2016 13:07:09 +0800
MIME-Version: 1.0
In-Reply-To: <6dbdc042-6b05-8270-e869-fcf95a99157d@gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 12/05/2016 11:49 AM, Calle Kabo wrote:
>
>> IMHO there will be 2 alternative method to recover:
>>
>> 1) Btrfs restore
>>    The safest method to recover files.
>>    Although it may need a lot of space to restore recovered data.
>>
>> 2) Btrfs check --init-extent-tree
>>    This will use fs tree to try to rebuild the extent tree.
>>    I don't believe it's only extent tree corrupted, so this may make
>>    things even *worse*, but at least it won't take several TBs to
>>    recover data which you may already have backup.
>
> Thanks! I tested restoring a small directory and it worked beautifully.
> Is there any way to list the files/directories? I don't think I can
> remember all of the paths that were on there...
>
> /Calle

I'm not familiar with btrfs-restore tool.
But a quick glance at the man page shows there is some options like
-r <rooid>
--path-regex <path>
-d
--list-roots
-D

Those options would help.
Maybe -D would list all the file structures?


And if btrfs restore works perfectly fine without even a problem,
then it seems to indicate that only extent tree is corrupted.
In that case, --init-extent-tree may have a little chance to recover the fs.
(But under most case, maybe over 50%?, it may make things worse)

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


