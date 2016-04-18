Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:56609 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750997AbcDRBUd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Apr 2016 21:20:33 -0400
Subject: Re: [PATCH] btrfs-progs: Restrict e2fsprogs version for new convert
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <1460615074-2492-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160415111726.GD28775@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <57143652.20206@cn.fujitsu.com>
Date: Mon, 18 Apr 2016 09:20:18 +0800
MIME-Version: 1.0
In-Reply-To: <20160415111726.GD28775@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2016/04/15 13:17 +0200:
> On Thu, Apr 14, 2016 at 02:24:34PM +0800, Qu Wenruo wrote:
>> New btrfs-convert is using a lot of new macro in e2fsprogs 1.42.
>> Unfortunately the new compatible layer for older e2fsprogs is still
>> under development.
>
> It hasn't been released yet so it's not really a big problem, although
> it makes testing on my side a bit harder. The configure-time check
> should be 1.41 and until it's fixed we can print a warning.
>
>
Did I missed something?

I checkout 1.41.14 and it shows no cluster support in ext2fs.h.

Also git describe shows it's v1.41.14-36-g1da5ef7, after the last v1.41 
version.

So I think the check should be 1.42, just as the patch.

Thanks,
Qu


