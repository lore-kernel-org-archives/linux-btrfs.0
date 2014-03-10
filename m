Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61934 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751675AbaCJHeW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 03:34:22 -0400
From: "quwenruo@cn.fujitsu.com" <quwenruo@cn.fujitsu.com>
To: =?utf-8?B?U3fDom1pIFBldGFyYW1lc2g=?= <swami@petaramesh.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel BUG: btrfs send - Incremental backup
Date: Mon, 10 Mar 2014 07:34:18 +0000
Message-ID: <531D6B3B.6030804@cn.fujitsu.com>
References: <2853810.EcqZt5vpol@tethys> <531D20A3.1030204@cn.fujitsu.com>
 <1975990.QvfbKRKJvK@tethys>
In-Reply-To: <1975990.QvfbKRKJvK@tethys>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 10 Mar 2014 08:25:26 +0100, SwÃ¢mi Petaramesh wrote:
> Le lundi 10 mars 2014 02:16:01 vous avez Ã©crit :
>> Does the filesystem pass the btrfsck?
>> If not, would you please try btrfsck first?
> It passes scrub with 0 errors... Do I need to bring it offline to pass btrfsck
> anyway ?
>
Better check it offline, since online check may not comprehensive than 
offline check.

Thanks.
Quÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
