Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23460 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750820AbcKCAWC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Nov 2016 20:22:02 -0400
Subject: Re: [PATCH v3 2/4] btrfs-progs: introduce new send-dump object
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20161101080147.13163-1-quwenruo@cn.fujitsu.com>
 <20161101080147.13163-3-quwenruo@cn.fujitsu.com>
 <20161101102209.GW12522@suse.cz>
 <e6a2018c-f335-9c6f-7152-87aea55fb5ec@cn.fujitsu.com>
 <20161102105229.GA12522@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <a0ab11b9-4894-4719-2a04-0e3ad53c379f@cn.fujitsu.com>
Date: Thu, 3 Nov 2016 08:21:53 +0800
MIME-Version: 1.0
In-Reply-To: <20161102105229.GA12522@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/02/2016 06:52 PM, David Sterba wrote:
> On Wed, Nov 02, 2016 at 08:37:20AM +0800, Qu Wenruo wrote:
>>> PATH_WIDTH is used only here, please hardcode it into the format string.
>>>
>>> The rest of the patch looks good. I think I've seen some artifacts in
>>> the output, but we can tune this later.
>>
>> Would you like to share the artifacts so I can handle them in next update?
>
> From the output of misc test 016:
>
> snapshot: [...] parent_transid= 14
>                                ^ extra space
>
> set_xattr:      ./snap_creation/xattr_file      name=user.test, len=1
>                                                               ^ comma
>
> also set xattr does not print the attribute data.

Thanks, I'll fix them.

Thanks,
Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


