Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37151 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753773Ab3LPPJU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 10:09:20 -0500
From: Chris Mason <clm@fb.com>
To: "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] Btrfs: avoid building inode cache repeatly
Date: Mon, 16 Dec 2013 15:09:15 +0000
Message-ID: <1387206565.18897.4.camel@ret.masoncoding.com>
References: <1387178735-30832-1-git-send-email-bo.li.liu@oracle.com>
	 <1387178735-30832-2-git-send-email-bo.li.liu@oracle.com>
In-Reply-To: <1387178735-30832-2-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2013-12-16 at 15:25 +0800, Liu Bo wrote:
> Inode cache is similar to free space cache and in fact shares the same
> code, however, we don't load inode cache unless we're about to allocate
> inode id, then there is a case where we only commit the transaction during
> other operations, such as snapshot creation, we now update fs roots' generation
> to the new transaction id, after that when we want to load the inode cache,
> we'll find that it's not valid thanks to the mismatch of generation, and we
> have to push btrfs-ino-cache thread to build inode cache from disk, and
> this operation is sometimes time-costing.
> 
> So to fix the above, we load inode cache into memory during reading fs root.

Please reorder these so the patch that causes problems comes after the
patches that fix the problems ;)  IOW, please make it bisect friendly.

-chris

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
