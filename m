Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:55694 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435AbbIZIEA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Sep 2015 04:04:00 -0400
Subject: Re: [PATCH] btrfs-progs: convert: Print different error message if
 convert partly failed.
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
References: <1433836660-1163-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150925175749.GQ11442@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <56065162.2030604@gmx.com>
Date: Sat, 26 Sep 2015 16:03:46 +0800
MIME-Version: 1.0
In-Reply-To: <20150925175749.GQ11442@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



在 2015年09月26日 01:57, David Sterba 写道:
> On Tue, Jun 09, 2015 at 03:57:40PM +0800, Qu Wenruo wrote:
>> When testing under libguestfs, btrfs-convert will never succeed to fix
>> chunk map, and always fails.
>>
>> But in that case, it's already a mountable btrfs.
>> So better to info user with different error message for that case.
>>
>> The root cause of it is still under investigation.
>>
>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>
> I've adjusted wording of the error message and applied, thanks. What are
> the consequences of the unfinished conversion process when such
> filesystem is mounted?

The whole chunk tree will not be in system chunk but metadata chunk, 
until COW happens.

But the funny thing is, even the system chunk is empty after the 
convert, with empty bg auto remove in recent kernels, it will try to 
remove empty system chunk, and cause COW...
And magically, things will become normal again(If chunk tree only has leaf).

Quite tricky to debug why open_ctree() will fail, as libguestfs is such 
a strange environment, not good method to debug and even no way to use 
gdb...

Thanks,
Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
