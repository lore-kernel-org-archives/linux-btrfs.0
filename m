From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: add checks to verify dir items are correct
Date: Thu, 17 Mar 2011 10:19:12 -0400
Message-ID: <1300371540-sup-2646@think>
References: <1300308591-3594-1-git-send-email-josef@redhat.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <1300308591-3594-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Josef Bacik's message of 2011-03-16 16:49:51 -0400:
> We need to make sure the dir items we get are valid dir items.  So any time we
> try and read one check it with verify_dir_item, which will do various sanity
> checks to make sure it looks sane.  Thanks,

Nice, could you please add this to your pull tree?

-chris
