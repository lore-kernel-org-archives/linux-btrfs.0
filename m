Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:59102 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751756AbeBCJHu (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Feb 2018 04:07:50 -0500
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "quwenruo.btrfs@gmx.com" <quwenruo.btrfs@gmx.com>
Subject: RE: [RFC PATCH v2 2/4] btrfs-progs: Add EXEC represent path of
 executable file
Date: Sat, 3 Feb 2018 09:07:47 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D016B127127@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1517560445-5712-1-git-send-email-gujx@cn.fujitsu.com>
 <1517560445-5712-3-git-send-email-gujx@cn.fujitsu.com>
 <20180202180730.GA18553@twin.jikos.cz>
In-Reply-To: <20180202180730.GA18553@twin.jikos.cz>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Saturday, February 03, 2018 2:08 AM
> To: Gu, Jinxiang/¹Ë ½ğÏã <gujx@cn.fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org; dsterba@suse.cz; quwenruo.btrfs@gmx.com
> Subject: Re: [RFC PATCH v2 2/4] btrfs-progs: Add EXEC represent path of executable file
> 
> On Fri, Feb 02, 2018 at 04:34:03PM +0800, Gu Jinxiang wrote:
> > Use EXEC instead of TOP to represent the path of excutable file.
> > EXEC is set to TOP by default, but when there is no excutable file in
> > TOP, use the path where btrfs is install as EXEC.
> 
> What if we just allow to change TOP (ie. do not overwrite it in the test driver scripts)? The logic will be the same as with EXEC, but we won't
> have to rewrite essentailly all paths in the testsuite.
> 
Since besides executable files, TOP is also used to find $TOP/tests/common, $TOP/Documentation, $TOP/tests/fuzz-tests/images, i.e.
so, change TOP will also effect on those resources.

So, I introduce EXEC to differentiate executable files and other resources.



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
