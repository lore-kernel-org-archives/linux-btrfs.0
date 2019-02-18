Return-Path: <SRS0=oOJ3=QZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD77BC43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 15:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACDC7217F9
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Feb 2019 15:36:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbfBRPgx (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Feb 2019 10:36:53 -0500
Received: from mx2.suse.de ([195.135.220.15]:41552 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726875AbfBRPgx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Feb 2019 10:36:53 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0D32BAD17;
        Mon, 18 Feb 2019 15:36:50 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8822ADA870; Mon, 18 Feb 2019 16:38:14 +0100 (CET)
Date:   Mon, 18 Feb 2019 16:38:14 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Hugo Mills <hugo@carfax.org.uk>,
        Filipe Manana <fdmanana@kernel.org>, dsterba@suse.cz,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] Btrfs: check if destination root is read-only for
 deduplication
Message-ID: <20190218153814.GL9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>,
        Filipe Manana <fdmanana@kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181212180559.15249-1-fdmanana@kernel.org>
 <20181212180559.15249-4-fdmanana@kernel.org>
 <20181213160740.GE23615@twin.jikos.cz>
 <CAL3q7H7T4Nercz9ZYtq_2yjpiPVjUX8+1xuvxnqnaDsip0bmYw@mail.gmail.com>
 <20190131164439.GC4461@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190131164439.GC4461@carfax.org.uk>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 31, 2019 at 04:44:39PM +0000, Hugo Mills wrote:
> On Thu, Jan 31, 2019 at 04:39:22PM +0000, Filipe Manana wrote:
> > On Thu, Dec 13, 2018 at 4:08 PM David Sterba <dsterba@suse.cz> wrote:
> > >
> > > On Wed, Dec 12, 2018 at 06:05:58PM +0000, fdmanana@kernel.org wrote:
> > > > From: Filipe Manana <fdmanana@suse.com>
> > > >
> > > > Checking if the destination root is read-only was being performed only for
> > > > clone operations. Make deduplication check it as well, as it does not make
> > > > sense to not do it, even if it is an operation that does not change the
> > > > file contents (such as defrag for example, which checks first if the root
> > > > is read-only).
> > >
> > > And this is also change in user-visible behaviour of dedupe, so this
> > > needs to be verified if it's not breaking existing tools.
> > 
> > Have you had the chance to do such verification?
> > 
> > This actually conflicts with send. Send does not expect a root/tree to
> > change, and with dedupe on read-only roots happening
> > in parallel with send is going to cause all sorts of unexpected and
> > undesired problems...
> > 
> > This is a problem introduced by dedupe ioctl when it landed, since
> > send existed for a longer time (when nothing else was
> > allowed to change read-only roots, including defrag).
> > 
> > I understand it can break some applications, but adding other solution
> > such as preventing send and dedupe from running in parallel
> > (erroring out or block and wait for each other, etc) is going to be
> > really ugly. There's always the workaround for apps to set the
> > subvolume
> > to RW mode, do the dedupe, then switch it back to RO mode.
> 
>    Only if you want your incremental send chain to break on the way
> past...
> 
>    I think it's fairly clear by now (particularly from the last thread
> on this a couple of weeks ago) that making RO subvols RW and then back
> again is a fast way to broken incremental receives.

So, I think the way it should be fixed is to keep deduplication off the
read-only subvolumes. The main reason I see is to avoid the random
problems that arise from send + dedupe interaction. The cost is lower
deduplication ratio.

The main usecase being a primary subvolume with RO snapshots over time,
with optional incremental send. That I know is common and widely used.

A problematic usecase that would utilize deduplication over RO snapshots
does could be something like a set of subvolumes that have very similar
data, get snapshotted or set RO, followed by a dedupe pass.

To support the latter I'd go only via the RO->RW, dedupe, RW->RO way, as
this records that there was a change and does not collide with send
assumptions. That this leads to loss of incremental send must be
communicated to the user with possible override, eg. --I-know-what-I-am-doing
option.
