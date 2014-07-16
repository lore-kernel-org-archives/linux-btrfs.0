Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38616 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753122AbaGPVeQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Jul 2014 17:34:16 -0400
Date: Wed, 16 Jul 2014 23:34:12 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: viro@zeniv.linux.org.uk, clm@fb.com, jbacik@fb.com,
        linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffm@suse.com, fdmanana@suse.com
Subject: Re: [RFC 0/2] vfs / btrfs: add support for ustat()
Message-ID: <20140716213412.GP10393@wotan.suse.de>
References: <1405465625-1122-1-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1405465625-1122-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 15, 2014 at 04:07:03PM -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> ustat() does not work for btrfs, the reason is the VFS layer
> cannot get to the super block from the anonymous bdevs. The
> way these are used within btrfs though are to actually use a
> series of them per superblock. This modifies the way the
> VFS exposes these bdevs by pegging them onto the super
> block on a linked list. This should also allow us to grow
> the subdevices on the super block with any other information
> that might be better suited underneath so that the VFS
> layer is aware. If this approach is reasonable then perhaps
> we should next remove the exported symbol for get_anon_bdev()
> as btrfs was the only user.
> 

Based on some private review I got this can be simplified leaving
the embedded the struct on the fs data structure and just using
it to expose it on the VFS. Will send a v2.

  Luis
