Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:54991 "EHLO
        homiemail-a115.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750819AbdEBSTe (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 14:19:34 -0400
Date: Tue, 02 May 2017 11:19:28 -0700
In-Reply-To: <20170502160133.GQ23260@twin.jikos.cz>
References: <1ff02889-4c01-acb6-cfc0-48433a86bdf8@asilaycomputing.com> <20170502160133.GQ23260@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: [PATCH] Tidy while loop in end_compressed_writeback
To: David Sterba <dsterba@suse.cz>
CC: linux-btrfs@vger.kernel.org
From: Sahil Kang <sahil.kang@asilaycomputing.com>
Message-ID: <D052BBF4-F20F-46CF-8104-E2AE7C0D3417@asilaycomputing.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I didn't consider it before, but I agree with your point on explicitly handling the return value from find_get_pages_contig.

Thanks for looking over it,
Sahil


-------- Original Message --------
From: David Sterba <dsterba@suse.cz>
Sent: May 2, 2017 9:01:34 AM PDT
To: Sahil Kang <sahil.kang@asilaycomputing.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Tidy while loop in end_compressed_writeback

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
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
