Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:45956 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaDNFIj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Apr 2014 01:08:39 -0400
Date: Mon, 14 Apr 2014 06:08:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] odd thing in btrfs_file_aio_write()
Message-ID: <20140414050834.GS18016@ZenIV.linux.org.uk>
References: <20140414002625.GQ18016@ZenIV.linux.org.uk>
 <534B495C.6060504@cn.fujitsu.com>
 <20140414024830.GR18016@ZenIV.linux.org.uk>
 <534B57D5.9070901@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <534B57D5.9070901@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 14, 2014 at 11:36:53AM +0800, Qu Wenruo wrote:
> >IOW, is that if (start_pos > i_size_read(inode)) { in there correct
> >these days?  And what'll happen if we hit e.g. an unmapped page in the
> >middle of the data being written?  That will result in short write, but
> >will it truncate what's left of that dummy range?
> I'm very sorry for my poor that I could not understand the question well.
> Would you please explain what does the "unmapped page" means?
> 
> Did you mean two noncontinuous iovecs?
> If you did mean that, it seems that I should expand the end_pos to
> the end of the iovec...

I mean that the very first (and only) iovec can very well span an area
that has been munmapped():

	char *buf = (char *)mmap(NULL, 65536, PROT_READ, MAP_ANON, -1, 0);
	memset(buf, 'A', 65536);
	munmap(buf + 4096, 4096);
	write(fd, buf, 65536);

or

	char *buf = (char *)mmap(NULL, 65536, PROT_READ, MAP_ANON, -1, 0);
	struct iovec iv = {buf, 65536};
	memset(buf, 'A', 65536);
	munmap(buf + 4096, 4096);
	writev(fd, &iv, 1);

will end up writing 4Kb of data (filled with 'A') and return 4096.  That's
how short writes happen...
