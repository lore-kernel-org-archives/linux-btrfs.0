Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:44913 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751228AbdJIByQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Oct 2017 21:54:16 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>
Subject: RE: [PATCH] btrfs: Use bd_dev to generate index when
 dev_state_hashtable add items.
Date: Mon, 9 Oct 2017 01:54:14 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01479C859B@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <1506672995-12488-1-git-send-email-gujx@cn.fujitsu.com>
 <20170929180529.GW31640@twin.jikos.cz>
In-Reply-To: <20170929180529.GW31640@twin.jikos.cz>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
sorry for reply too late.

This patch fix for the bug descriped below.
Use MOUNT_OPTIONS="-o check_int" when run xfstest, device
Can not be mount successfully. So xfstest can not run.



> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Saturday, September 30, 2017 2:05 AM
> To: Gu, Jinxiang/¹Ë ½ğÏã <gujx@cn.fujitsu.com>
> Cc: linux-btrfs@vger.kernel.org; hch@lst.de
> Subject: Re: [PATCH] btrfs: Use bd_dev to generate index when dev_state_hashtable add items.
> 
> On Fri, Sep 29, 2017 at 04:16:35PM +0800, Gu Jinxiang wrote:
> > From: Gu JinXiang <gujx@cn.fujitsu.com>
> >
> > Fix bug of
> > <f8f84b2dfda5> (<btrfs: index check-integrity state hash by a dev_t>).
> 
> Please explain what bug are you fixing.
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
