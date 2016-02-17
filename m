Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailer.hiddenmail.net ([199.195.249.9]:37271 "EHLO
	mailer.hiddenmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965013AbcBQX4U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Feb 2016 18:56:20 -0500
Received: from mailer by mailer.hiddenmail.net with local (Exim 4.80)
	(envelope-from <angel@fs.16bits.net>)
	id 1aWBxD-0005ah-00
	for linux-btrfs@vger.kernel.org; Thu, 18 Feb 2016 00:56:19 +0100
Message-ID: <1455753376.6690.8.camel@fs.16bits.net>
Subject: Re: bad extent [5993525264384, 5993525280768), type mismatch with
 chunk
From: =?ISO-8859-1?Q?=C1ngel_Gonz=E1lez?= <angel@fs.16bits.net>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Thu, 18 Feb 2016 00:56:16 +0100
In-Reply-To: <56C420A3.1000508@cn.fujitsu.com>
References: <1447365063.7045.7.camel@scientia.net>
	 <1455581697.6951.9.camel@fs.16bits.net> <56C27D8F.2000006@cn.fujitsu.com>
	 <1455661288.1700.8.camel@fs.16bits.net> <56C420A3.1000508@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo wrote:
> If you're really interesting in whether your fs has skinny metadata 
> enabled, you can check btrfs-show-super output.


> Like the following output indicates skinny metadata:
> ------
> incompat_flags		0x161
> 			( MIXED_BACKREF |
> 			  BIG_METADATA |
> 			  EXTENDED_IREF |
> 			  SKINNY_METADATA ) <<<Here
> ------
> 
> Even it has skinny metadata, it's still possible that some metadata
> are still in old format if you used btrfstune to convert an old fs to
> skinny metadata.

It was a freshly created filesystem. However, btrfs-show-super shows it
does *not* have skinny metadata:
> incompat_flags		0x61
> 			( MIXED_BACKREF |
> 			  BIG_METADATA |
> 			  EXTENDED_IREF )

Maybe gparted explicitely requested it to be created without skinny
metadata. That won't make me lose my sleep, though.


> But anyway, it's always good to see the problem solved.

Indeed :-)

Thanks again
