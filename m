Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754102AbbDTJq4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 05:46:56 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20150420193347.29378d69@notabene.brown>
References: <20150420193347.29378d69@notabene.brown> <20150420052752.26554.13596.stgit@notabene.brown> <20150420052558.26554.97143.stgit@notabene.brown> <30419.1429519662@warthog.procyon.org.uk>
To: NeilBrown <neilb@suse.de>
Cc: dhowells@redhat.com, Chris Mason <clm@fb.com>,
        Al Viro <viro@ZenIV.linux.org.uk>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 3/3] btrfs: set FS_SUPPORTS_SEEK_HOLE flag.
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 20 Apr 2015 10:46:49 +0100
Message-ID: <31824.1429523209@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

NeilBrown <neilb@suse.de> wrote:

> Missing patch 2 of the 3-patch series?

Yes. :-)

Do ext4 and xfs support this, do you know?

David
