Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from wp216.webpack.hosteurope.de ([80.237.132.223]:53149 "EHLO
	wp216.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbcCOXvH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 19:51:07 -0400
From: Andreas Grosse <andig.listen@aol.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Incompat features: raid56 ... when creating a RAID6?
Date: Wed, 16 Mar 2016 00:51:02 +0100
Message-ID: <2241137.7FlY2XkjWK@andilaptop>
In-Reply-To: <56E88A7C.1010801@oracle.com>
References: <16570443.SxVegaKaET@andilaptop> <56E88A7C.1010801@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 16. März 2016, 06:19:40 CET schrieben Sie:
>   Those messages are indeed confusing. It just indicates the
>   FS may fail to mount on certain older kernels. Not necessarily
>   the kernel in the system on which you ran btrfs-progs. Sorry
>   that it not very obvious at the moment, but there are patches
>   to make this part better.
> 
>   To check features that your running kernel supports you could use
>    ls /sys/fs/btrfs/features
> 
>   But note: Some of the names used by sys/fs/..features don't
>   exactly match with the names used by btrfs-progs: incompatible..
>   (a bug, which is also fixed in the patch).
> 
> Thanks, Anand

Hello Anand,

thanks for the detailed reply. Good to hear, those things are already patched. 
I thought that I could not be the only one who misunderstood "Incompat".
Thanks for the hint with the sys-files!

Andi

One more question: Any idea what happened here? Did I send this garbage? This 
was at the very end of your response mail...
> > (If important: Gentoo Linux with kernel 4.5.0, btrfs-progs v4.4.1)
> > 
> > AndiN‹§²æìr¸›yúèšØb²X¬¶Ç§vØ^–)Þº{.nÇ+‰·¥Š{±nÚß²)í…æèw*jg¬±¨¶‰šŽŠÝ¢j/êäz
> > ¹Þ–Šà2ŠÞ™¨è­Ú&¢)ß¡«a¶Úþø®G«éh®æj:+v‰¨Šwè†Ù¥

