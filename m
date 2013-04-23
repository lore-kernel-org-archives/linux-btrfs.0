Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59758 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757094Ab3DWQrR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Apr 2013 12:47:17 -0400
Date: Tue, 23 Apr 2013 18:47:12 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Anand Jain <anand.jain@oracle.com>,
        Alexander Block <ablock84@googlemail.com>
Subject: Re: [PATCH 2/2 V2] btrfs-progs: update generation_v2 in
 btrfs_update_root
Message-ID: <20130423164712.GW16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5174C426.3030204@redhat.com>
 <5174C704.7040603@redhat.com>
 <5174C7B9.8000802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5174C7B9.8000802@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 22, 2013 at 12:16:41AM -0500, Eric Sandeen wrote:
> This addresses the same issue as did:
> 
> 2bd1169 btrfs-progs: root_item generation_v2 is out of sync after btrfsck
> 
> but rather than optionally updating generation_v2 based
> on the size of the existing item, increase the size of the
> item as needed, and unconditionally set generation_v2.
> This matches the kernel code, and keeping things in sync is a
> Good Thing.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: give it a better, more descriptive subject/summary
> 
> kdave - since you already had Anand's patch on the integration
> branch, I dunno if you want to add this on top, or just replace
> it with a similar patch to this, up to you.

I'm going to replace the patch (the integration branches are not linear
and could be rebased, the purpose is to catch such issues earlier so the
patch queue is moderately clean when it gets pulled).

thanks,
david
