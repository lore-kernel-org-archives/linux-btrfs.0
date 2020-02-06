Return-Path: <SRS0=9o53=32=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A7FC33CAC
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Feb 2020 17:00:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB7BB20838
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Feb 2020 17:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727599AbgBFRAE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Feb 2020 12:00:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:47472 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgBFRAE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Feb 2020 12:00:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 6C43FAE17;
        Thu,  6 Feb 2020 17:00:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6EC85DA790; Thu,  6 Feb 2020 17:59:49 +0100 (CET)
Date:   Thu, 6 Feb 2020 17:59:49 +0100
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/44][v5] Cleanup how we handle root refs, part 1
Message-ID: <20200206165949.GA2654@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <20200124143301.2186319-1-josef@toxicpanda.com>
 <20200205154840.GU2654@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205154840.GU2654@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Feb 05, 2020 at 04:48:41PM +0100, David Sterba wrote:
> On Fri, Jan 24, 2020 at 09:32:17AM -0500, Josef Bacik wrote:
> > v4->v5:
> > - split out the btrfs_free_fs_info() moving around into it's own patch.
> > - updated a comment in btrfs_get_root() to describe why we are initializing part
> >   of the fs_info
> 
> I've commented under the patches, small things that I'd rather fixup
> in my branch once you look at them, no need to resend anything.
> 
> As the code is split, some changes are removed so even if there's
> something called in wrong order, it lasts only a few patches. For
> clarity I'd still like to have committed patches that don't have such
> things left.

All fixups done, I'll add the branch to misc-next.
