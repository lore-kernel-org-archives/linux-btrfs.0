Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:21667 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750770AbaDNCeS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 22:34:18 -0400
Message-ID: <534B495C.6060504@cn.fujitsu.com>
Date: Mon, 14 Apr 2014 10:35:08 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>, Chris Mason <clm@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: Re: [RFC] odd thing in btrfs_file_aio_write()
References: <20140414002625.GQ18016@ZenIV.linux.org.uk>
In-Reply-To: <20140414002625.GQ18016@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Oh, that's my fault, I forgot that iov can be chained.

I should use 'pos + count' instead.

Thanks for pointing it out.
Qu.

-------- Original Message --------
Subject: [RFC] odd thing in btrfs_file_aio_write()
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Chris Mason <clm@fb.com>
Date: 2014年04月14日 08:26
> 		end_pos = round_up(pos + iov->iov_len, root->sectorsize);
>
> added in commit 3ac0d7b96a268a98bd474cab8bce3a9f125aaccf
> Author: Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date:   Thu Mar 27 02:51:58 2014 +0000
>
>      btrfs: Change the expanding write sequence to fix snapshot related bug.
>
> doesn't look right - after all, just split the first iovec in the array
> and end_pos will go down.  Do we want pos + count instead of
> pos + iov->iov_len there?

