Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:45618 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaDNCsh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Apr 2014 22:48:37 -0400
Date: Mon, 14 Apr 2014 03:48:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] odd thing in btrfs_file_aio_write()
Message-ID: <20140414024830.GR18016@ZenIV.linux.org.uk>
References: <20140414002625.GQ18016@ZenIV.linux.org.uk>
 <534B495C.6060504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <534B495C.6060504@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 14, 2014 at 10:35:08AM +0800, Qu Wenruo wrote:
> Oh, that's my fault, I forgot that iov can be chained.
> 
> I should use 'pos + count' instead.

BTW, will there be any difference if 10Mb write starts one byte before EOF?
IOW, is that if (start_pos > i_size_read(inode)) { in there correct
these days?  And what'll happen if we hit e.g. an unmapped page in the
middle of the data being written?  That will result in short write, but
will it truncate what's left of that dummy range?
