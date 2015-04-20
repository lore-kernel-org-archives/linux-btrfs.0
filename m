Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:35236 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbbDTJpn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 05:45:43 -0400
Date: Mon, 20 Apr 2015 02:45:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: NeilBrown <neilb@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>,
        Chris Mason <clm@fb.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
        linux-cachefs@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] fscache/cachefiles: optionally use SEEK_DATA instead
 of ->bmap.
Message-ID: <20150420094539.GA12622@infradead.org>
References: <20150420052558.26554.97143.stgit@notabene.brown>
 <20150420052752.26554.52672.stgit@notabene.brown>
 <20150420060818.GA32675@infradead.org>
 <20150420162700.3e69c7db@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150420162700.3e69c7db@notabene.brown>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 20, 2015 at 04:27:00PM +1000, NeilBrown wrote:
> A worthwhile goal, but I certainly wouldn't consider pursuing it until what I
> have submitted so far as been accepted - let's not reject "good" while
> waiting for "perfect".

It's still broken.  You add conditional flag for the almost right
(almost because the flag in the filesystem type needs to go) while
leaving the broken option th default.  So what you propose here is not
good, it's at best just as bad as the old version because you don't
remove broken code but add a lot more clutter at the same time.
