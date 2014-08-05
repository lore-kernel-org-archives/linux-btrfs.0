Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:1668 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932700AbaHEIvu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Aug 2014 04:51:50 -0400
Message-ID: <53E09B20.4020305@cn.fujitsu.com>
Date: Tue, 5 Aug 2014 16:51:44 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Peter Waller <peter@scraperwiki.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: ENOSPC with mkdir and rename
References: <CAFChkqtpb+xMhFk+7RBux-o-FOO0oaxx28Wz-LZZZVpvq2nRFQ@mail.gmail.com> <53DEE40C.6020403@cn.fujitsu.com> <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
In-Reply-To: <CAFChkqttiPWQ+FquT2FfKE54US7vkeEyQsUT8fuD1BWNhS3k=w@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: ENOSPC with mkdir and rename
From: Peter Waller <peter@scraperwiki.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年08月04日 16:14
> Thanks for responses.
>
> All of this is *very* surprising. I'm not new to BTRFS, I've been
> using it on my own machines for multiple years. I didn't realise there
> was an un-holstered footgun on my lap at this point. How can it be
> made clear how to avoid the ENOSPC problem to myself and other
> sysadmins? Or preferably not exist as a problem?
[snip]

In fact such "defeat"(or whatever) is not really btrfs only problem.
In ext*, there is still similiar behavior: ext* has a up limit on the 
number of inode after mkfs.
(When you mkfs.ext*, you are prompt the up limit of inodes)
However other metadata in ext* is stored together with data, so no 
ENOSPC problem like btrfs.

Btrfs only makes ENOSPC easier to happen by completly split data and 
metadata, and does extra
data reserve for metadata.

If you like the ext* way, as already mentioned you can mkfs.btrfs with 
-M flag.

But IMO, some tuning in btrfs chunk allocation algorithm may helps.
For example, we have a 20G disk, and 14G space is allocated to 
data/metadata chunks.
Under such sitiuation, if btrfs needs new data chunk, it will allocate 
up to 10% of disk, which is 2G.
But if it comes to metadata, it will only allocate up to 256M metadata 
chunk.
This makes it very easy to allocate the rest of space all to data chunk.

But if btrfs can use the free space in a more diligent way when space is 
not enough,
metadata and data usage should be more balanced and less ENOSPC will occur.

If nobody dislike the idea, I'd like try to implent this later.

Thanks,
Qu

