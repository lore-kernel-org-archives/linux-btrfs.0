Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71CE3C65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 18:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 213742086D
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 18:18:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 213742086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727952AbeLMSSH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 13:18:07 -0500
Received: from mx2.suse.de ([195.135.220.15]:53510 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727775AbeLMSSH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 13:18:07 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 233F2AF99;
        Thu, 13 Dec 2018 18:18:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 014C8DA7EE; Thu, 13 Dec 2018 19:17:41 +0100 (CET)
Date:   Thu, 13 Dec 2018 19:17:41 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 0/8][V2] Enospc cleanups and fixeS
Message-ID: <20181213181741.GJ23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20181203152459.21630-1-josef@toxicpanda.com>
 <20181213141111.GC23615@twin.jikos.cz>
 <20181213144554.pec3brfojs53smiv@macbook-pro-91.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181213144554.pec3brfojs53smiv@macbook-pro-91.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 13, 2018 at 09:45:55AM -0500, Josef Bacik wrote:
> On Thu, Dec 13, 2018 at 03:11:11PM +0100, David Sterba wrote:
> > On Mon, Dec 03, 2018 at 10:24:51AM -0500, Josef Bacik wrote:
> > > v1->v2:
> > > - addressed comments from reviewers.
> > > - fixed a bug in patch 6 that was introduced because of changes to upstream.
> > > 
> > > -- Original message --
> > > 
> > > The delayed refs rsv patches exposed a bunch of issues in our enospc
> > > infrastructure that needed to be addressed.  These aren't really one coherent
> > > group, but they are all around flushing and reservations.
> > > may_commit_transaction() needed to be updated a little bit, and we needed to add
> > > a new state to force chunk allocation if things got dicey.  Also because we can
> > > end up needed to reserve a whole bunch of extra space for outstanding delayed
> > > refs we needed to add the ability to only ENOSPC tickets that were too big to
> > > satisfy, instead of failing all of the tickets.  There's also a fix in here for
> > > one of the corner cases where we didn't quite have enough space reserved for the
> > > delayed refs we were generating during evict().  Thanks,
> > 
> > One testbox reports an assertion failure on current for-next,
> > generic/224. I'm reporting it under this patchset as it's my best guess.
> > Same host running misc-next (with the delayed rsv patchset) was fine and
> > the run with for-next (including this patchset) fails. The assertion is
> > 
> >  5225 static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
> >  5226                                     struct btrfs_space_info *space_info,
> >  5227                                     u64 orig_bytes,
> >  5228                                     enum btrfs_reserve_flush_enum flush,
> >  5229                                     bool system_chunk)
> >  5230 {
> >  5231         struct reserve_ticket ticket;
> >  5232         u64 used;
> >  5233         u64 reclaim_bytes = 0;
> >  5234         int ret = 0;
> >  5235
> >  5236         ASSERT(orig_bytes);
> >  ^^^^
> > 
> 
> Looking at your for-next branch on your github (I assume this is what you are
> testing)
> 
> https://github.com/kdave/btrfs-devel/blob/for-next-20181212/fs/btrfs/extent-tree.c
> 
> at line 5860 there's supposed to be a 
> 
> if (num_bytes == 0)
> 	return 0
> 
> that's what I changed in v2 of this patchset, as I hit this bug as well.  It

What does 'this' refer to? The patchset in this mail thread? If yes,
then something's wrong, because in the patch

https://patchwork.kernel.org/patch/10709827/

there's a clear ASSERT(orig_bytes) in the context of one hunk:

@@ -5210,6 +5217,7 @@  static int __reserve_metadata_bytes(struct btrfs_fs_info *fs_info,
 {
 	struct reserve_ticket ticket;
 	u64 used;
+	u64 reclaim_bytes = 0;
 	int ret = 0;
 
 	ASSERT(orig_bytes);
---

> looks like you still have v1 of this patchset applied.  Thanks,

I looked up the patch series on patchwork too to double check that I haven't
missed it in my mailboxes but no.

The assert was introduced by "Btrfs: introduce ticketed enospc infrastructure"
which is quite old. The v2 of that patch is

https://lore.kernel.org/linux-btrfs/1463506255-15918-1-git-send-email-jbacik@fb.com/

and also has the assert and not if (orig_bytes). Confused.
