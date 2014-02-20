Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postfix.iai.uni-bonn.de ([131.220.8.4]:52163 "EHLO
	postfix.iai.uni-bonn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaBTL0y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 06:26:54 -0500
Message-ID: <5305E63B.4000405@informatik.uni-bonn.de>
Date: Thu, 20 Feb 2014 12:25:47 +0100
From: Sebastian Ochmann <ochmann@informatik.uni-bonn.de>
MIME-Version: 1.0
To: wangsl.fnst@cn.fujitsu.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Meaning of \"no_csum\" field when scrubbing with -R option
References: <5305DE1E.8080302@cn.fujitsu.com>
In-Reply-To: <5305DE1E.8080302@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

>     Sebastian Ochmann posted on Wed, 19 Feb 2014 13:58:17 +0100 as excerpted:
>
>
>         So my question is, why does scrub show a high (i.e. non-zero) value for
>         no_csum? I never enabled nodatasum or a similar option.
>
> Did you enable nodatacow option? if  nodatacow option is enabled,
> data checksums will be also disabled at the same time.

No, never, not even on single files. Some additional info: The 
filesystem is only a few weeks old (even though I see similar results on 
an older filesystem as well), it's my root filesystem, and as mount 
options I use "rw,noatime,ssd,discard,space_cache" (it's on a SSD). 
Kernel version is 3.12.9.

Best regards,
Sebastian
