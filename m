Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:52645 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbbJLDTw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 11 Oct 2015 23:19:52 -0400
Subject: Re: [PATCH] btrfs: remove empty header file extent-tree.h
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        Chris Mason <clm@fb.com>
References: <1435886274-8309-1-git-send-email-quwenruo@cn.fujitsu.com>
 <5609EEBF.2010804@cn.fujitsu.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <561B26A5.2090804@gmx.com>
Date: Mon, 12 Oct 2015 11:19:01 +0800
MIME-Version: 1.0
In-Reply-To: <5609EEBF.2010804@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ping?

Any comment?

Thanks,
Qu

Qu Wenruo wrote on 2015/09/29 09:51 +0800:
> Hi Chris,
>
> Would you please merge this patch?
>
> The empty header is introduced by my qgroup accounting rework, and the
> cleanup patch is missed in 4.2.
>
> Thanks,
> Qu
>
> Qu Wenruo wrote on 2015/07/03 09:17 +0800:
>> The empty file is introduced as an careless 'git add', remove it.
>>
>> Reported-by: David Sterba <dsterba@suse.cz>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> ---
>>   fs/btrfs/extent-tree.h | 0
>>   1 file changed, 0 insertions(+), 0 deletions(-)
>>   delete mode 100644 fs/btrfs/extent-tree.h
>>
>> diff --git a/fs/btrfs/extent-tree.h b/fs/btrfs/extent-tree.h
>> deleted file mode 100644
>> index e69de29..0000000
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
