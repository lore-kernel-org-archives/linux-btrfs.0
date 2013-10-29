Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab3J2TW2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Oct 2013 15:22:28 -0400
Date: Tue, 29 Oct 2013 12:22:26 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: stop using vfs_read in send
Message-ID: <20131029192226.GB17681@lenny.home.zabbo.net>
References: <1382715473-3949-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382715473-3949-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry for the latency.  I was away last week.

On Fri, Oct 25, 2013 at 11:37:53AM -0400, Josef Bacik wrote:
> Apparently we don't actually close the files until we return to userspace, so
> stop using vfs_read in send.  This is actually better for us since we can avoid
> all the extra logic of holding the file we're sending open and making sure to
> clean it up.

Good stuff.

A few things:

> +	pgoff_t index = offset >> PAGE_CACHE_SHIFT;
> +	pgoff_t last_index;
> +	unsigned pg_offset = offset & (PAGE_CACHE_SIZE - 1);

	unsigned pg_offset = offset & ~PAGE_CACHE_MASK;

> +	if (offset + len > i_size_read(inode)) {

I worry about offset + len wrapping but I didn't check the caller to see
if that's possible.

> +	while (index <= last_index) {
> +		unsigned cur_len = min_t(unsigned, len, PAGE_CACHE_SIZE);

Careful, this'd insert some random kernel memory after the first partial
page.

		unsigned cur_len = min_t(unsigned, len, PAGE_CACHE_SIZE - pg_off);

> +		addr = kmap(page);
> +		memcpy(sctx->read_buf + ret, addr + pg_offset, cur_len);
> +		kunmap(page);
> +		unlock_page(page);

I think you need flush_dcache_page() before reading from user mappable
page cache pages.  (Need to make sure that potential cached stores at
other user virtual addreses are flushed before we read from the kernel
mapping.)

- z
