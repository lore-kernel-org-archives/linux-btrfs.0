Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59969 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754551AbdKASCa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Nov 2017 14:02:30 -0400
Date: Wed, 1 Nov 2017 19:00:39 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Roman Mamedov <rm@romanrm.net>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: Move loop termination condition in while()
Message-ID: <20171101180039.GH3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1509528738-4387-1-git-send-email-nborisov@suse.com>
 <20171101144632.7c0b9e95@natsu>
 <5cfe8dab-eadf-069a-4abf-bbb0d696d214@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5cfe8dab-eadf-069a-4abf-bbb0d696d214@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 01, 2017 at 12:42:18PM +0200, Nikolay Borisov wrote:
> 
> 
> On  1.11.2017 11:46, Roman Mamedov wrote:
> > On Wed,  1 Nov 2017 11:32:18 +0200
> > Nikolay Borisov <nborisov@suse.com> wrote:
> > 
> >> Fallocating a file in btrfs goes through several stages. The one before actually
> >> inserting the fallocated extents is to create a qgroup reservation, covering
> >> the desired range. To this end there is a loop in btrfs_fallocate which checks
> >> to see if there are holes in the fallocated range or !PREALLOC extents past EOF
> >> and if so create qgroup reservations for them. Unfortunately, the main condition
> >> of the loop is burried right at the end of its body rather than in the actual
> >> while statement which makes it non-obvious. Fix this by moving the condition
> >> in the while statement where it belongs. No functional changes.
> > 
> > If it turns out that "cur_offset >= alloc_end" from the get go, previously the
> > loop body would be entered and executed once. With this change, it will not
> > anymore.
> 
> Good point, however this cannot happen, because for this to happen then
> the following 2 expression need to be equal:
> 
> alloc_start = round_down(offset, blocksize);
> alloc_end = round_up(offset + len, blocksize);
> 
> However, len is guaranteed to be > 0  due to a check in vfs_fallocate so
> those can't really be equal.

Agreed, and

Reviewed-by: David Sterba <dsterba@suse.com>
