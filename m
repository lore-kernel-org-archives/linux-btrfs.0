Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbbDTLWS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 07:22:18 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20150420052752.26554.52672.stgit@notabene.brown>
References: <20150420052752.26554.52672.stgit@notabene.brown> <20150420052558.26554.97143.stgit@notabene.brown>
To: NeilBrown <neilb@suse.de>
Cc: dhowells@redhat.com, Chris Mason <clm@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, linux-cachefs@vger.kernel.org,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] fscache/cachefiles: optionally use SEEK_DATA instead of ->bmap.
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 20 Apr 2015 12:21:42 +0100
Message-ID: <3914.1429528902@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

NeilBrown <neilb@suse.de> wrote:

> @@ -721,24 +733,45 @@ int cachefiles_read_or_alloc_pages(struct fscache_retrieval *op,

We can actually do better than this what you've done here for
cachefiles_read_or_alloc_pages().  We can use SEEK_DATA to check the beginning
of a run of pages and then SEEK_HOLE to see how many pages are covered.

David
