Return-Path: <SRS0=fY4Z=NX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A755C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 22:03:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50C6E22360
	for <linux-btrfs@archiver.kernel.org>; Mon, 12 Nov 2018 22:03:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 50C6E22360
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728325AbeKMH5K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 13 Nov 2018 02:57:10 -0500
Received: from mx2.suse.de ([195.135.220.15]:50740 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726006AbeKMH5K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Nov 2018 02:57:10 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BDDE5B124;
        Mon, 12 Nov 2018 22:02:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 70C5BDAFAE; Mon, 12 Nov 2018 23:01:48 +0100 (CET)
Date:   Mon, 12 Nov 2018 23:01:47 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        David Sterba <dsterba@suse.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v9 0/6] Btrfs: implement swap file support
Message-ID: <20181112220147.GT24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, David Sterba <dsterba@suse.com>,
        linux-fsdevel@vger.kernel.org
References: <cover.1538072009.git.osandov@fb.com>
 <20181106095451.GG9136@twin.jikos.cz>
 <20181107144937.GE24115@twin.jikos.cz>
 <aec6451b-1198-7888-9dbc-0d6576d1ea4e@suse.com>
 <20181107152810.GF24115@twin.jikos.cz>
 <20181110041239.GB23447@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181110041239.GB23447@vader>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Nov 09, 2018 at 08:12:39PM -0800, Omar Sandoval wrote:
> On Wed, Nov 07, 2018 at 04:28:10PM +0100, David Sterba wrote:
> > On Wed, Nov 07, 2018 at 05:07:00PM +0200, Nikolay Borisov wrote:
> > > 
> > > 
> > > On 7.11.18 г. 16:49 ч., David Sterba wrote:
> > > > On Tue, Nov 06, 2018 at 10:54:51AM +0100, David Sterba wrote:
> > > >> On Thu, Sep 27, 2018 at 11:17:32AM -0700, Omar Sandoval wrote:
> > > >>> From: Omar Sandoval <osandov@fb.com>
> > > >>> This series implements swap file support for Btrfs.
> > > >>>
> > > >>> Changes from v8 [1]:
> > > >>>
> > > >>> - Fixed a bug in btrfs_swap_activate() which would cause us to miss some
> > > >>>   file extents if they were merged into one extent map entry.
> > > >>> - Fixed build for !CONFIG_SWAP.
> > > >>> - Changed all error messages to KERN_WARN.
> > > >>> - Unindented long error messages.
> > > >>>
> > > >>> I've Cc'd Jon and Al on patch 3 this time, so hopefully we can get an
> > > >>> ack for that one, too.
> > > >>>
> > > >>> Thanks!
> > > >>>
> > > >>> 1: https://www.spinics.net/lists/linux-btrfs/msg82267.html
> > > >>>
> > > >>> Omar Sandoval (6):
> > > >>>   mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
> > > >>>   mm: export add_swap_extent()
> > > >>>   vfs: update swap_{,de}activate documentation
> > > >>>   Btrfs: prevent ioctls from interfering with a swap file
> > > >>>   Btrfs: rename get_chunk_map() and make it non-static
> > > >>>   Btrfs: support swap files
> > > >>
> > > >> fstest generic/472 reports an assertion failure. This is on the updated fstests
> > > >> git (70c4067285b0bc076), though it should not matter:
> > > >>
> > > >> [16597.002190] assertion failed: IS_ALIGNED(start, fs_info->sectorsize) && IS_ALIGNED(end + 1, fs_info->sectorsize), file: fs/btrfs/file-item.c, line: 319
> > > > 
> > > > I have to revert the patch for now as it kills the testing machines.
> > > 
> > > The reason is that the isize is not aligned to a sectorsize. Ie it
> > > should be:
> > > 
> > > +       u64 isize = ALIGN_DOWN(i_size_read(inode), fs_info->sectorsize);
> > > 
> > > With this fixlet generic/472 succeeds.
> > 
> > Thanks for the fix, I'll fold it in.
> 
> Thanks, Nikolay, I missed that. I don't think i_size_read() is
> necessary, though, since the inode is locked.

Indeed, i_size used and patch pushed to misc-next.
