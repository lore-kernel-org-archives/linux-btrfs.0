Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:32946 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731113AbeGSRUo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Jul 2018 13:20:44 -0400
Date: Thu, 19 Jul 2018 18:36:35 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH 01/22] btrfs: add btrfs_delete_ref_head helper
Message-ID: <20180719163635.GX26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180719145006.17532-1-josef@toxicpanda.com>
 <20180719160821.GW26141@twin.jikos.cz>
 <20180719161251.irm6x6kd327mxsc6@destiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180719161251.irm6x6kd327mxsc6@destiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 12:12:52PM -0400, Josef Bacik wrote:
> On Thu, Jul 19, 2018 at 06:08:21PM +0200, David Sterba wrote:
> > Please send cover letter for patchsets with more than 1 patch.
> > Especially for a patchset with 20+ patches that does not seem to be
> > doing anything trivial.
> > 
> > What problem does this fix, what's the overall idea behind the approach,
> > what workload can trigger that etc.
> 
> They are just fixes, there's no large over-arching theme, hence no cover letter,

Cover letter is a single point where I can address the whole patchset,
like that it's added to for-next or merged, or report bugs. Also you are
going to write what are the changes between the revisions.

The initial text does not need to be long if there's really nothing big
behind, but please state that in advance. This sets the expectations
before one is going through the patches.
