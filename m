Return-Path: <SRS0=dEEl=PX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6ED61C43444
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:27:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DD0A20651
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Jan 2019 17:27:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388331AbfAOR1M (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Jan 2019 12:27:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:53982 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730575AbfAOR1M (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Jan 2019 12:27:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5CB77AD14;
        Tue, 15 Jan 2019 17:27:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C594FDA83D; Tue, 15 Jan 2019 18:26:42 +0100 (CET)
Date:   Tue, 15 Jan 2019 18:26:42 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     David Disseldorp <ddiss@suse.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 3/3] Btrfs-progs: add test for receive
Message-ID: <20190115172642.GI2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        David Disseldorp <ddiss@suse.de>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
References: <20190114133146.18424-1-fdmanana@kernel.org>
 <20190114150817.394e4f7d@suse.de>
 <CAL3q7H6cHf8U4pqPDNEA=g_kC_gOhccyE0a1CaS8N3QxdDSCWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H6cHf8U4pqPDNEA=g_kC_gOhccyE0a1CaS8N3QxdDSCWg@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Jan 14, 2019 at 02:11:17PM +0000, Filipe Manana wrote:
> On Mon, Jan 14, 2019 at 2:08 PM David Disseldorp <ddiss@suse.de> wrote:
> >
> > On Mon, 14 Jan 2019 13:31:46 +0000, fdmanana@kernel.org wrote:
> >
> > > From: Filipe Manana <fdmanana@suse.com>
> > >
> > > Add a test for a scenario that used to fail due to find_mount_root()
> > > incorrectly determining the mount point for the receive path due to the
> > > fact that a different mount point with a path that is a prefix of the
> > > receive path exists.
> > >
> > > This is fixed by a recent patch titled:
> > >
> > >   "Btrfs-progs: fix mount point detection due to partial prefix match"
> > >
> > > Reported-by: David Disseldorp <ddis@suse.com>
> >
> > My address has an extra 's' (ddiss). This also applies to PATCH 1/3.
> 
> Ops.
> David can probably correct that when he picks the patch, otherwise

All fixed and applied, thanks.
