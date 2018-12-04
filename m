Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8DEC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 12:49:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1746D20878
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 12:49:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1746D20878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbeLDMtC (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 07:49:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:33254 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725767AbeLDMtC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 07:49:02 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 98D1DAF53;
        Tue,  4 Dec 2018 12:48:59 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 22A92DA7A3; Tue,  4 Dec 2018 13:48:41 +0100 (CET)
Date:   Tue, 4 Dec 2018 13:48:41 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v1.1 9/9] btrfs-progs: Cleanup warning reported by
 -Wmissing-prototypes
Message-ID: <20181204124841.GN17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20181116075426.4142-10-wqu@suse.com>
 <20181116080451.6306-1-wqu@suse.com>
 <20181204122207.GM17773@twin.jikos.cz>
 <b319920a-b315-f07f-5410-c0798632d2db@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b319920a-b315-f07f-5410-c0798632d2db@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 04, 2018 at 08:24:38PM +0800, Qu Wenruo wrote:
> 
> 
> On 2018/12/4 下午8:22, David Sterba wrote:
> > On Fri, Nov 16, 2018 at 04:04:51PM +0800, Qu Wenruo wrote:
> >> The following missing prototypes will be fixed:
> >> 1)  btrfs.c::handle_special_globals()
> >> 2)  check/mode-lowmem.c::repair_ternary_lowmem()
> >> 3)  extent-tree.c::btrfs_search_overlap_extent()
> >>     Above 3 can be fixed by making them static
> >>
> >> 4)  utils.c::btrfs_check_nodesize()
> >>     Fixed by moving it to fsfeatures.c
> >>
> >> 5)  chunk-recover.c::btrfs_recover_chunk_tree()
> >> 6)  super-recover.c::btrfs_recover_superblocks()
> >>     Fixed by moving the declaration from cmds-rescue.c to rescue.h
> >>
> >> 7)  utils-lib.c::arg_strtou64()
> >> 8)  utils-lib.c::lookup_path_rootid()
> >>     Fixed by include "utils.h"
> >>
> >> 9)  free-space-tree.c::set_free_space_tree_thresholds()
> >>     Fixed by deleting it, as there is no user.
> >>
> >> 10) free-space-tree.c::convert_free_space_to_bitmaps()
> >> 11) free-space-tree.c::convert_free_space_to_extents()
> >> 12) free-space-tree.c::__remove_from_free_space_tree()
> >> 13) free-space-tree.c::__add_to_free_space_tree()
> >> 14) free-space-tree.c::btrfs_create_tree()
> >>     Fixed by making them static.
> > 
> > Please split this to more patches grouped by the type of change.
> 
> No problem, just as the numbering is already grouped.

Note that 1-3 and 10-14 are the same group.
