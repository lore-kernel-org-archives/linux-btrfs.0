Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA45C04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 15:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C74BE214C1
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 15:57:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C74BE214C1
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbeLFP5T (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 10:57:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:54192 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725936AbeLFP5T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 10:57:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 57531AEB1;
        Thu,  6 Dec 2018 15:57:17 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C8C68DAB92; Thu,  6 Dec 2018 16:56:55 +0100 (CET)
Date:   Thu, 6 Dec 2018 16:56:53 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 00/10][V2] Delayed refs rsv
Message-ID: <20181206155653.GG3905@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20181203152038.21388-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181203152038.21388-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Dec 03, 2018 at 10:20:28AM -0500, Josef Bacik wrote:
> v1->v2:
> - addressed the comments from the various reviewers.
> - split "introduce delayed_refs_rsv" into 5 patches.  The patches are the same
>   together as they were, just split out more logically.  They can't really be
>   bisected across in that you will likely have fun enospc failures, but they
>   compile properly.  This was done to make it easier for review.

Thanks, that was helpful. The bisectability is IMO not hurt, as it
compiles and runs despite the potential ENOSPC problems. I guess the
point is to be able to reach any commit & compile & run and not be hit
by unrelated bugs. If somebody is bisecting an ENOSPC problem and lands
in the middle of the series, there's a hint in the changelogs that
something is going on.

> -- Original message --
> 
> This patchset changes how we do space reservations for delayed refs.  We were
> hitting probably 20-40 enospc abort's per day in production while running
> delayed refs at transaction commit time.  This means we ran out of space in the
> global reserve and couldn't easily get more space in use_block_rsv().
> 
> The global reserve has grown to cover everything we don't reserve space
> explicitly for, and we've grown a lot of weird ad-hoc hueristics to know if
> we're running short on space and when it's time to force a commit.  A failure
> rate of 20-40 file systems when we run hundreds of thousands of them isn't super
> high, but cleaning up this code will make things less ugly and more predictible.
> 
> Thus the delayed refs rsv.  We always know how many delayed refs we have
> outstanding, and although running them generates more we can use the global
> reserve for that spill over, which fits better into it's desired use than a full
> blown reservation.  This first approach is to simply take how many times we're
> reserving space for and multiply that by 2 in order to save enough space for the
> delayed refs that could be generated.  This is a niave approach and will
> probably evolve, but for now it works.
> 
> With this patchset we've gone down to 2-8 failures per week.  It's not perfect,
> there are some corner cases that still need to be addressed, but is
> significantly better than what we had.  Thanks,

I've merged the series to misc-next, the amount of reviews and testing
is sufficient. Though there are some more comments or suggestions for
improvements, they can be done as followups.

The other patchsets from you are namely fixes, that can be applied at
the -rc time, for that reason I'm glad the main infrastructure change
can be merged before the 4.21 code freeze.
