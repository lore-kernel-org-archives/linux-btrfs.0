Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:49543 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751236AbdI1GYv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Sep 2017 02:24:51 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH] btrfs-progs: Resolve memory-leak in btrfs qgroup show
 when quota disabled
Date: Thu, 28 Sep 2017 06:24:44 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01479BD6FB@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1506418111-26620-1-git-send-email-gujx@cn.fujitsu.com>
 <20170926112732.GP31640@twin.jikos.cz>
In-Reply-To: <20170926112732.GP31640@twin.jikos.cz>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
I am so sorry for that this patch brings a new problem of double free in normal scenes.
So I send a new patch .
Please revert this one and use the new patch.


> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Tuesday, September 26, 2017 7:28 PM
> To: Gu, Jinxiang/¹Ë ½ğÏã <gujx@cn.fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] btrfs-progs: Resolve memory-leak in btrfs qgroup show when quota disabled
> 
> On Tue, Sep 26, 2017 at 05:28:31PM +0800, Gu Jinxiang wrote:
> > When quota disabled, btrfs qgroup show exit with a error message, but
> > the allocated memory is not freed.
> >
> > By the way, this bug marked as issue#20 in github.
> >
> > Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> 
> Applied, thanks.
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
