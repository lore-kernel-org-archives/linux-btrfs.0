Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754814AbbDTJ2G (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 05:28:06 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20150420144956.1f489f67@notabene.brown>
References: <20150420144956.1f489f67@notabene.brown> <20150409174916.5a2efef5@notabene.brown> <29536.1428571388@warthog.procyon.org.uk> <20150410112431.0e9c337d@notabene.brown>
To: NeilBrown <neilb@suse.de>
Cc: dhowells@redhat.com, linux-btrfs@vger.kernel.org, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH/RFC] fscache/cachefiles versus btrfs
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 20 Apr 2015 10:27:57 +0100
Message-ID: <31056.1429522077@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

NeilBrown <neilb@suse.de> wrote:

> I managed to reproduce the bug, and when I applied your patches I cannot any
> more.  So it looks like you've fixed it - thanks.

I hope so too.  Now I just hope Linus takes the patches.

> That just leave the bmap issue.  I'll post a patch which causes lseek to be
> used when the fs says that is OK.

Okay, thanks.

David
