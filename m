Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab3BZSxc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 13:53:32 -0500
Date: Tue, 26 Feb 2013 10:53:20 -0800
From: Zach Brown <zab@redhat.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dave@jikos.cz>
Subject: Re: [PATCH] btrfs: cleanup for open-coded alignment
Message-ID: <20130226185320.GJ1658@lenny.home.zabbo.net>
References: <1361866222-5746-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1361866222-5746-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Sometimes these open-coded alignment is not so easy to understand for
> newbie like me.

Thanks, this is a nice change.

You might have mentioned in the commit message that some of the changes
aren't *strictly* equivalent but that they're still safe.

> -		iosize = (iosize + blocksize - 1) & ~((u64)blocksize - 1);
> +		iosize = ALIGN(iosize, blocksize);

This is equivalent to

> +		iosize = (iosize + blocksize - 1) & ~((size_t)blocksize - 1);

Which is fine.  That u64 was overkill.  The manual casts only need to
make sure that the mask is as wide as the input value to avoid losing
bits and the macro now guarantees that.

> -	num_bytes = (end - start + blocksize) & ~(blocksize - 1);
> +	num_bytes = ALIGN(end - start + 1, blocksize);

Nice catch.

Reviewed-by: Zach Brown <zab@redhat.com>

- z
