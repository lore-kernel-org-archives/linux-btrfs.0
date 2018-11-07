Return-Path: <SRS0=udTi=NS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D97C0044C
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 14:49:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 731CB2085B
	for <linux-btrfs@archiver.kernel.org>; Wed,  7 Nov 2018 14:49:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 731CB2085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727698AbeKHAUc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 7 Nov 2018 19:20:32 -0500
Received: from mx2.suse.de ([195.135.220.15]:47576 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726766AbeKHAUc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Nov 2018 19:20:32 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 54F11B62B;
        Wed,  7 Nov 2018 14:49:51 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EAA69DAD1F; Wed,  7 Nov 2018 15:49:37 +0100 (CET)
Date:   Wed, 7 Nov 2018 15:49:37 +0100
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.cz>
Cc:     Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, David Sterba <dsterba@suse.com>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v9 0/6] Btrfs: implement swap file support
Message-ID: <20181107144937.GE24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org
References: <cover.1538072009.git.osandov@fb.com>
 <20181106095451.GG9136@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181106095451.GG9136@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 06, 2018 at 10:54:51AM +0100, David Sterba wrote:
> On Thu, Sep 27, 2018 at 11:17:32AM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > This series implements swap file support for Btrfs.
> > 
> > Changes from v8 [1]:
> > 
> > - Fixed a bug in btrfs_swap_activate() which would cause us to miss some
> >   file extents if they were merged into one extent map entry.
> > - Fixed build for !CONFIG_SWAP.
> > - Changed all error messages to KERN_WARN.
> > - Unindented long error messages.
> > 
> > I've Cc'd Jon and Al on patch 3 this time, so hopefully we can get an
> > ack for that one, too.
> > 
> > Thanks!
> > 
> > 1: https://www.spinics.net/lists/linux-btrfs/msg82267.html
> > 
> > Omar Sandoval (6):
> >   mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
> >   mm: export add_swap_extent()
> >   vfs: update swap_{,de}activate documentation
> >   Btrfs: prevent ioctls from interfering with a swap file
> >   Btrfs: rename get_chunk_map() and make it non-static
> >   Btrfs: support swap files
> 
> fstest generic/472 reports an assertion failure. This is on the updated fstests
> git (70c4067285b0bc076), though it should not matter:
> 
> [16597.002190] assertion failed: IS_ALIGNED(start, fs_info->sectorsize) && IS_ALIGNED(end + 1, fs_info->sectorsize), file: fs/btrfs/file-item.c, line: 319

I have to revert the patch for now as it kills the testing machines.
