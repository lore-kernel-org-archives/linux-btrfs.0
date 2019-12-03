Return-Path: <SRS0=ifAh=ZZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76FF6C432C0
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 19:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50B2220675
	for <linux-btrfs@archiver.kernel.org>; Tue,  3 Dec 2019 19:06:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfLCTGe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 14:06:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:58556 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726057AbfLCTGe (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Dec 2019 14:06:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7BDADB2938;
        Tue,  3 Dec 2019 19:06:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CA909DA7D9; Tue,  3 Dec 2019 20:06:27 +0100 (CET)
Date:   Tue, 3 Dec 2019 20:06:27 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     dsterba@suse.cz, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        Qu Wenruo <wqu@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: Fix btrfs_find_create_tree_block() testing
Message-ID: <20191203190627.GW2734@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dan Carpenter <dan.carpenter@oracle.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <20191203110408.GA30629@linux.ibm.com>
 <20191203112457.GF1787@kadam>
 <20191203184039.GU2734@twin.jikos.cz>
 <20191203184601.GI1787@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203184601.GI1787@kadam>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 03, 2019 at 09:46:01PM +0300, Dan Carpenter wrote:
> On Tue, Dec 03, 2019 at 07:40:39PM +0100, David Sterba wrote:
> > On Tue, Dec 03, 2019 at 02:24:58PM +0300, Dan Carpenter wrote:
> > > The btrfs_find_create_tree_block() uses alloc_test_extent_buffer() for
> > > testing and alloc_extent_buffer() for production.  The problem is that
> > > the test code returns NULL and the production code returns error
> > > pointers.  The callers only check for error pointers.
> > > 
> > > I have changed alloc_test_extent_buffer() to return error pointers and
> > > updated the two callers which use it directly.
> > > 
> > > Fixes: faa2dbf004e8 ("Btrfs: add sanity tests for new qgroup accounting code")
> > > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > 
> > I edited the changelog because btrfs_find_create_tree_block is
> > misleading and seems to be unrelated to the actual fix that's just for
> > alloc_test_extent_buffer. Patch added to misc-next, thanks.
> 
> The bug is in btrfs_find_create_tree_block()
> 
> fs/btrfs/disk-io.c
>   1046  struct extent_buffer *btrfs_find_create_tree_block(
>   1047                                                  struct btrfs_fs_info *fs_info,
>   1048                                                  u64 bytenr)
>   1049  {
>   1050          if (btrfs_is_testing(fs_info))
>   1051                  return alloc_test_extent_buffer(fs_info, bytenr);
>                         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> NULL
> 
>   1052          return alloc_extent_buffer(fs_info, bytenr);
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Error pointers.
> 
>   1053  }
> 
> None of the callers of btrfs_find_create_tree_block() check for NULL.

I see, though my view is a bug in alloc_test_extent_buffer that should
follow alloc_extent_buffer semantics, and this gets fixed. I'll update
the changelog again, makes sense to mention that it namely affects
btrfs_find_create_tree_block.
