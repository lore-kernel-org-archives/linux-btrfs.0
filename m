Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:64742 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726503AbeHHGGG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Aug 2018 02:06:06 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        "Lu, Fengqi" <lufq.fnst@cn.fujitsu.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH 2/5] btrfs: use a separate variable to store the
 num_bytes of the qgroup_reserve
Date: Wed, 8 Aug 2018 03:48:22 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8A3EBC7@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <20180804131057.9967-1-lufq.fnst@cn.fujitsu.com>
 <20180804131057.9967-3-lufq.fnst@cn.fujitsu.com>
 <20180807161912.GO3218@twin.jikos.cz>
In-Reply-To: <20180807161912.GO3218@twin.jikos.cz>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Wednesday, August 08, 2018 12:19 AM
> To: Lu, Fengqi/Â½ ·á÷è <lufq.fnst@cn.fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org; Gu, Jinxiang/¹Ë ½ğÏã <gujx@cn.fujitsu.com>
> Subject: Re: [PATCH 2/5] btrfs: use a separate variable to store the num_bytes of the qgroup_reserve
> 
> On Sat, Aug 04, 2018 at 09:10:54PM +0800, Lu Fengqi wrote:
> > After btrfs_qgroup_reserve_meta_prealloc(), num_bytes will be assigned
> > again by btrfs_calc_trans_metadata_size(). Therefore, once block_rsv
> > fails, we cannot properly free the num_bytes of the previous
> > qgroup_reserve.
> 
> This does not look like a trivial cleanup at all. There was an unused
> parameter, removed in c4c129db5da8f070147f175 ("btrfs: drop unused
> parameter qgroup_reserved"), that introduced the bug.  
Yes. It was introduced by fix above.
I missed the second assignment of num_bytes.
And it should use two variable to record reserve size of qgroup and blockgroup.


>This was in this
> rc1 so it's a regression and I'll consider pushing it to the 4.18 final.
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
