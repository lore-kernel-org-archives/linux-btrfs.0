Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44377 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751083AbdFAPAX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Jun 2017 11:00:23 -0400
Date: Thu, 1 Jun 2017 16:59:16 +0200
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, dsterba@suse.com, clm@fb.com,
        jeffm@suse.com
Subject: Re: [PATCH 0/2] space_info update/creation refactoring
Message-ID: <20170601145916.GH12135@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1494318859-7555-1-git-send-email-nborisov@suse.com>
 <20170601144605.GF12135@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170601144605.GF12135@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 01, 2017 at 04:46:05PM +0200, David Sterba wrote:
> On Tue, May 09, 2017 at 11:34:17AM +0300, Nikolay Borisov wrote:
> > Here are two patches which aim to disentangle and make more explicit 
> > the situation when a space_info has to be created VS when space_info values 
> > are being updated. 
> > 
> > It survived multiple xfstest runs with additional ASSERTs which I have removed
> > in this posting. One such assert which didn't trigger was in 
> > btrfs_make_block_group. Despite that I haven't changed the logic of the code
> > to try and allocate a space_info if one can't be found. However, I'd like 
> > someone more knowledgble of the internals of bg lifecycle to tell me if 
> > in fact btrfs_make_block_group can be called with flags for non-existant 
> > struct space_info. 
> > 
> > 
> > 
> > Nikolay Borisov (2):
> >   btrfs: Separate space_info create/update
> >   btrfs: Refactor update_space_info
> 
> I don't see an updated version of this patchset, Jeff had some comments
> that are beyond what I normally fix during commit. Please fix and
> resend, thanks.

Never mind, I did not see it in the main inbox, because it's been
already added to the for-next queue.
