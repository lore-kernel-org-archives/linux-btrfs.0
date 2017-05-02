Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46977 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751007AbdEBQBl (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 12:01:41 -0400
Date: Tue, 2 May 2017 18:01:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Sahil Kang <sahil.kang@asilaycomputing.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Tidy while loop in end_compressed_writeback
Message-ID: <20170502160133.GQ23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1ff02889-4c01-acb6-cfc0-48433a86bdf8@asilaycomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ff02889-4c01-acb6-cfc0-48433a86bdf8@asilaycomputing.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 19, 2017 at 05:43:19AM -0700, Sahil Kang wrote:
> This is my first patch so it's a minor code change.
> I think removing the early continue from the loop makes the function a 
> little easier to follow.

I think the opposite. In the current code, it's clear that if ret is 0,
then there's a shortcut. While your code change is functionally
equivalent, it takes a bit more time to see that the for loop does
nothing if ret == 0 and overall it looks like we don't handle the return
value coming from find_get_pages_contig, in exchange for some ?:
trickery that requires a comment.

So I don't think this patch makes code better and I'm not going to apply
it, sorry.
