Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwkm01.jp.fujitsu.com ([202.219.69.168]:31250 "EHLO
	mgwkm01.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbcGLEub (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 00:50:31 -0400
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
	by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 28DFAAC00A1
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Jul 2016 13:50:27 +0900 (JST)
Subject: Re: [PATCH v12.1 01/15] btrfs: expand cow_file_range() to support
 in-band dedup and subpage-blocksize
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org,
        Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
References: <20160711030543.30115-1-quwenruo@cn.fujitsu.com>
 <20160711030543.30115-2-quwenruo@cn.fujitsu.com>
 <20160711164129.GA13336@suse.cz>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <1980ebdd-a630-cf0f-1807-c76e26f5b6a8@jp.fujitsu.com>
Date: Tue, 12 Jul 2016 13:50:11 +0900
MIME-Version: 1.0
In-Reply-To: <20160711164129.GA13336@suse.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/07/12 1:41, David Sterba wrote:
> On Mon, Jul 11, 2016 at 11:05:29AM +0800, Qu Wenruo wrote:
>> From: Wang Xiaoguang <wangxg.fnst@cn.fujitsu.com>
>>
>> Extract cow_file_range() new parameters for both in-band dedupe and
>> subpage sector size patchset.
>>
>> This should make conflict of both patchset to minimal, and reduce the
>> effort needed to rebase them.
> 
> Great, thanks. I did a test merge, there are still conflicts but they
> seem to be resolvable more easily, picking the changes from the right
> patchset. I haven't tested it so there's more work, but the point was to
> get the conflict surface down.
> 
> There's another candidate, btrfs_set_extent_delalloc as it adds a
> parameter, can you please send a similar patch for that?

He's going to attend LinuxCon Japan (Jul 13 - Jul 15).
So I guess he will reply several days later (next week?).

Thanks,
Satoru

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
