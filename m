Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755051AbbDTIsT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 04:48:19 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20150420052752.26554.13596.stgit@notabene.brown>
References: <20150420052752.26554.13596.stgit@notabene.brown> <20150420052558.26554.97143.stgit@notabene.brown>
To: NeilBrown <neilb@suse.de>
Cc: dhowells@redhat.com, Chris Mason <clm@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-cachefs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: set FS_SUPPORTS_SEEK_HOLE flag.
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 20 Apr 2015 09:47:42 +0100
Message-ID: <30419.1429519662@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

NeilBrown <neilb@suse.de> wrote:

> +	.fs_flags	= FS_REQUIRES_DEV | FS_BINARY_MOUNTDATA |
> +			  FS_SUPPORTS_SEEK_HOLE,

I must be missing something:

	warthog>git merge linus/master
	Already up-to-date.
	warthog>stg id
	09d51602cf84a1264946711dd4ea0dddbac599a1
	warthog>grep -r FS_SUPPORTS_SEEK_HOLE include/
	warthog1>git grep FS_SUPPORTS_SEEK_HOLE
	warthog1>

David
