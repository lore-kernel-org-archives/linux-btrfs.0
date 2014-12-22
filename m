Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:2537 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750928AbaLVIRo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 03:17:44 -0500
Message-ID: <5497D3A9.8040900@cn.fujitsu.com>
Date: Mon, 22 Dec 2014 16:17:45 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>, <clm@fb.com>
Subject: Re: Btrfs progs pre-release 3.18-rc2
References: <20141219182130.GL27601@twin.jikos.cz>
In-Reply-To: <20141219182130.GL27601@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Btrfs progs pre-release 3.18-rc2
From: David Sterba <dsterba@suse.cz>
To: <linux-btrfs@vger.kernel.org>
Date: 2014年12月20日 02:21
> Hi
>
> another step towards 3.18, the changes are limited in scope and mostly
> cleanups or docs. I'd like to see more test images for new fsck code,
> there are 2 new that I missed earlier, so they don't count.
>
> The timing with end of the year is not good so if I'm not confident
> that the release is in a good shape I'm rather going to postpone it.
> Alternatively, I can do a release on Monday and then use the following
> weeks to prepare a .1 bugfix release.
>
> Known problems: the image 013 fails
Hi david,

I'm doing the btrfsck test framework tweaks, it will not be a big change 
but it will change the original
dir hierarchy, including moving of all the binary/btrfs-image dump to 
different dirs
(some dir may contains several images).

I'm afraid it may also delay 3.18 progs release, so just info you in 
advance.

Thanks,
Qu
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

