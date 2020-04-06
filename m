Return-Path: <SRS0=ixrC=5W=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E652C2BA1E
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Apr 2020 17:27:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F2AF24A03
	for <linux-btrfs@archiver.kernel.org>; Mon,  6 Apr 2020 17:27:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbgDFR1h (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 6 Apr 2020 13:27:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:48404 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbgDFR1h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Apr 2020 13:27:37 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id D9702BD74;
        Mon,  6 Apr 2020 17:27:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DD48DDA726; Mon,  6 Apr 2020 17:53:44 +0200 (CEST)
Date:   Mon, 6 Apr 2020 17:53:44 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>,
        Johannes Hirte <johannes.hirte@datenkhaos.de>
Subject: Re: [PATCH] Btrfs: fix lost i_size update after cloning inline extent
Message-ID: <20200406155344.GN5920@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Johannes Hirte <johannes.hirte@datenkhaos.de>
References: <20200404202022.30192-1-fdmanana@kernel.org>
 <CAL3q7H6cZS7mq7d6aHPxMPnng_P7nuMHaBi=F4L86CoHhFZVJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H6cZS7mq7d6aHPxMPnng_P7nuMHaBi=F4L86CoHhFZVJg@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Apr 06, 2020 at 11:51:20AM +0100, Filipe Manana wrote:
> On Sat, Apr 4, 2020 at 9:21 PM <fdmanana@kernel.org> wrote:
> >
> > From: Filipe Manana <fdmanana@suse.com>
> >
> > When not using the NO_HOLES feature we were not marking the destination's
> > file range as written after cloning an inline extent into it. This can
> > lead to a data loss if the current destination file size is smaller than
> > the source file's size.
> >
> > Example:
> >
> >   $ mkfs.btrfs -f -O ^no-holes /dev/sdc
> >   $ mount /mnt/sdc /mnt
> >
> >   $ echo "hello world" > /mnt/foo
> >   $ cp --reflink=always /mnt/foo /mnt/bar
> >   $ rm -f /mnt/foo
> >   $ umount /mnt
> >
> >   $ mount /mnt/sdc /mnt
> >   $ cat /mnt/bar
> >   $
> >   $ stat -c %s /mnt/bar
> >   0
> >
> >   # -> the file is empty, since we deleted foo, the data lost is forever
> >
> > Fix that by calling btrfs_inode_set_file_extent_range() after cloning an
> > inline extent.
> >
> > A test case for fstests will follow soon.
> >
> > Fixes: 9ddc959e802bf ("btrfs: use the file extent tree infrastructure")
> > Signed-off-by: Filipe Manana <fdmanana@suse.com>
> 
> Reported-by: Johannes Hirte <johannes.hirte@datenkhaos.de>
> Link: https://lore.kernel.org/linux-btrfs/20200404193846.GA432065@latitude/
> Tested-by: Johannes Hirte <johannes.hirte@datenkhaos.de>

Thanks, added to misc-next.
