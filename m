Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60544 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753054AbeGDQz3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 12:55:29 -0400
Date: Wed, 4 Jul 2018 18:55:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Ethan Lien <ethanlien@synology.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: use correct compare function of
 dirty_metadata_bytes
Message-ID: <20180704165527.GA3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180702074458.16270-1-ethanlien@synology.com>
 <068bb6e1-78b9-ed1c-f9e2-08e90de5e928@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <068bb6e1-78b9-ed1c-f9e2-08e90de5e928@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 02, 2018 at 10:49:46AM +0300, Nikolay Borisov wrote:
> On  2.07.2018 10:44, Ethan Lien wrote:
> > We use customized, nodesize batch value to update dirty_metadata_bytes.
> > We should also use batch version of compare function or we will easily
> > goto fast path and get false result from percpu_counter_compare().
> > 
> > Signed-off-by: Ethan Lien <ethanlien@synology.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
> Also this needs the following tag: 
> 
> Fixes: e2d845211eda ("Btrfs: use percpu counter for dirty metadata count")

I'll add the tags, thanks.

2939         fs_info->dirty_metadata_batch = nodesize * (1 + ilog2(nr_cpu_ids));

What a commit, sigh. Arbitrary constants without any explanation. I
don't quite understand why the ilog2(nr_cpui_ids) was chosen. If cpus
are onlined/offlined there's no adjustment. I'd think that there should
be some amount of data that are supposed to be dirtied per-cpu and this
value is independent of the number of cpus. That the online/offline
status is abstracted by the percpu API. I don't have time to study that
too deeply, but this is something that needs to be revisited.
