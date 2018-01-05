Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45899 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751109AbeAEMxX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jan 2018 07:53:23 -0500
Date: Fri, 5 Jan 2018 13:51:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 RESEND] Btrfs: make raid6 rebuild retry more
Message-ID: <20180105125115.GH3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180102203642.14105-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180102203642.14105-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 02, 2018 at 01:36:41PM -0700, Liu Bo wrote:
> There is a scenario that can end up with rebuild process failing to
> return good content, i.e.
> suppose that all disks can be read without problems and if the content
> that was read out doesn't match its checksum, currently for raid6
> btrfs at most retries twice,
> 
> - the 1st retry is to rebuild with all other stripes, it'll eventually
>   be a raid5 xor rebuild,
> - if the 1st fails, the 2nd retry will deliberately fail parity p so
>   that it will do raid6 style rebuild,
> 
> however, the chances are that another non-parity stripe content also
> has something corrupted, so that the above retries are not able to
> return correct content, and users will think of this as data loss.
> More seriouly, if the loss happens on some important internal btree
> roots, it could refuse to mount.
> 
> This extends btrfs to do more retries and each retry fails only one
> stripe.  Since raid6 can tolerate 2 disk failures, if there is one
> more failure besides the failure on which we're recovering, this can
> always work.
> 
> The worst case is to retry as many times as the number of raid6 disks,
> but given the fact that such a scenario is really rare in practice,
> it's still acceptable.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

1 and added to for-next.
