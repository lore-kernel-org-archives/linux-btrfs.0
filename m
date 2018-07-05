Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54638 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751324AbeGEPTB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Jul 2018 11:19:01 -0400
Date: Thu, 5 Jul 2018 17:18:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] Enhancement for block group/chunk verification
Message-ID: <20180705151859.GI3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180703091009.16399-1-wqu@suse.com>
 <20180704133607.GQ3126@twin.jikos.cz>
 <c80e2352-2edd-bacf-4c22-e51155bca7d4@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <c80e2352-2edd-bacf-4c22-e51155bca7d4@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 05, 2018 at 09:36:47AM +0800, Qu Wenruo wrote:
> 
> 
> On 2018年07月04日 21:36, David Sterba wrote:
> > On Tue, Jul 03, 2018 at 05:10:04PM +0800, Qu Wenruo wrote:
> >> Can be fetched from github, which is based on v4.18-rc1 tag:
> >> https://github.com/adam900710/linux/tree/tree_checker_enhance
> >>
> >> Reported by Xu Wen <wen.xu@gatech.edu>, some crafted btrfs image can
> >> cause unexpected kernel behavior.
> >>
> >> All of them are related to block group and chunk, so this patchset will
> >> enhance block group and chunk verification, so kernel can detect them
> >> and error out gracefully (with user friendly error message showing
> >> what's going wrong)
> >>
> >> Obvious corruption (don't need to cross check with chunk/block group),
> >> will be addressed by enhanced tree-checker.
> >> (Most crafted images will be caught by tree-checker)
> >>
> >> More complex corruption will be addressed mostly at
> >> btrfs_read_block_groups(), doing extra cross reference check for
> >> chunk<->block group mapping.
> >> It may cause extra mount time, but compared to the existing time
> >> consuming block group items search, all added check is done completely
> >> in memory using rb_tree, so it shouldn't add too much overhead.
> >>
> >> Qu Wenruo (5):
> >>   btrfs: tree-checker: Verify block_group_item
> >>   btrfs: tree-checker: Detect invalid empty essential tree
> >>   btrfs: relocation: Only remove reloc rb_trees if reloc control has
> >>     been initialized
> >>   btrfs: Check each block group has corresponding chunk at mount time
> >>   btrfs: Verify every chunk has corresponding block group at mount time
> > 
> > Patches 1-3 queued, thanks. 4 and 5 have some comments.
> 
> Did I miss the comments for 4 and 5?

Gu has a question regarding patch 4 a and 5 now from me too.
