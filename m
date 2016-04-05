Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:7401 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751718AbcDEB2k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 4 Apr 2016 21:28:40 -0400
Subject: Re: [PATCH] btrfs-progs: fsck: Fix a false metadata extent warning
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1459390774-12424-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160331163006.GE6230@twin.jikos.cz> <56FDC0A2.1030909@cn.fujitsu.com>
 <20160401084418.GI6230@suse.cz> <56FE363E.5090202@cn.fujitsu.com>
 <20160404111852.GG9918@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <570314BF.209@cn.fujitsu.com>
Date: Tue, 5 Apr 2016 09:28:31 +0800
MIME-Version: 1.0
In-Reply-To: <20160404111852.GG9918@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/04/04 13:18 +0200:
> On Fri, Apr 01, 2016 at 04:50:06PM +0800, Qu Wenruo wrote:
>>> After another look, why don't we use nodesize directly? Or stripesize
>>> where applies. With max_size == 0 the test does not make sense, we ought
>>> to know the alignment.
>>>
>>>
>> Yes, my first though is also to use nodesize directly, which should be
>> always correct.
>>
>> But the problem is, the related function call stack doesn't have any
>> member to reach btrfs_root or btrfs_fs_info.
>
> JFYI, there's global_info avalaible, so it's not necessary to pass
> fs_info down the callstacks.
>
>
Oh, that's a good news.

Do I need to re-submit the patch to use fs_info->tree_root->nodesize to 
avoid false alert?
Or wait for your refactor?

Thanks,
Qu


