Return-Path: <SRS0=4/Cm=7E=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53241C433E0
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 May 2020 11:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D632206C3
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 May 2020 11:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbgEVLhk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 May 2020 07:37:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:58500 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728601AbgEVLhk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 May 2020 07:37:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 188B6ADCE;
        Fri, 22 May 2020 11:37:41 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 10164DA9B7; Fri, 22 May 2020 13:36:42 +0200 (CEST)
Date:   Fri, 22 May 2020 13:36:42 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc:     Christoph Hellwig <hch@infradead.org>, dsterba@suse.cz,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/9] btrfs: Switch to iomap_dio_rw() for dio
Message-ID: <20200522113642.GK18421@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Goldwyn Rodrigues <rgoldwyn@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org
References: <20200507061430.GA8939@infradead.org>
 <20200507113741.GJ18421@twin.jikos.cz>
 <20200507121037.GA25363@infradead.org>
 <20200508031405.br4dcibcyuoluxum@fiona>
 <20200509135914.GA4962@infradead.org>
 <20200510040601.bub3du7g5kepeakw@fiona>
 <20200512145807.GA23409@infradead.org>
 <20200512171927.tk46sbriqvhasvsq@fiona>
 <20200515141305.GA27936@infradead.org>
 <20200519201116.6qyoaxc7g2krxzzx@fiona>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200519201116.6qyoaxc7g2krxzzx@fiona>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, May 19, 2020 at 03:11:16PM -0500, Goldwyn Rodrigues wrote:
> On  7:13 15/05, Christoph Hellwig wrote:
> > FYI, generic/475 always fail on me for btrfs, due to the warnings on
> > transaction abort.
> > 
> > Anyway, I have come up with a version that seems to mostly work.
> > 
> > The main change is that btrfs_sync_file stashes away the journal handle.
> > I also had to merge parts of the ->iomap_end patch into the main iomap
> > one.  I also did some cleanups to my iomap changes while looking over it.
> > Let me know what you thing, the tree is here:
> > 
> >     git://git.infradead.org/users/hch/misc.git btrfs-dio
> > 
> > Gitweb:
> > 
> >     http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/btrfs-dio
> 
> I finally managed to fix the reservation issue and the final tree based
> on Dave's for-next is at:
> https://github.com/goldwynr/linux/tree/dio-merge
> 
> I will test it thoroughly and send another patchset.
> I will still need that iomap->private!

With the updated top commit 6cbb7a0c7b33d33e6 it passes fstests in my
setup, so that's the minimum for inclusion.

Regarding merge, I'm willing to add it to 5.8 queue still. In total it's
7 patches, 6 of which are preparatory or cleanups that have been
reviewed by several people. The switch to iomap is one patch and not a
huge one.

Sending the latest version proably makes sense so we have it in the
mailinglist, I can add the patches to misc-next right away so it gets
more testing exposure.

There have been other changes to our direct IO code so the testing focus
will be there anyway and reverting one or two patches as fallback is an
option, I think the risk of including the patches that close to merge
window is manageable.
