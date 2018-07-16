Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59206 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727953AbeGPMqB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Jul 2018 08:46:01 -0400
Date: Mon, 16 Jul 2018 14:18:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Use btrfs_mark_bg_unused() to replace open code
Message-ID: <20180716121842.GE3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180522084347.3381-1-wqu@suse.com>
 <20180522121455.GH6649@twin.jikos.cz>
 <be92bc31-f617-254b-a1b8-2f92de764295@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <be92bc31-f617-254b-a1b8-2f92de764295@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 27, 2018 at 09:25:25AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年05月22日 20:14, David Sterba wrote:
> > On Tue, May 22, 2018 at 04:43:47PM +0800, Qu Wenruo wrote:
> >> Introduce a small helper, btrfs_mark_bg_unused(), to accquire needed
> >> locks and add a block group to unused_bgs list.
> > 
> > The helper is nice but hides that there's a reference taken on the 'bg'.
> > This would be good to add at least to the function comment or somehow
> > squeeze it into the function name itself, like
> > btrfs_get_and_mark_bg_unused.
> 
> That btrfs_get_block_group() call is only for later removal.
> The reference will be removed in btrfs_delete_unused_bgs().
> 
> So I don't think the function name needs the "_get" part.

Agreed, it's inside the helpers. Patch added to misc-next, thanks.
