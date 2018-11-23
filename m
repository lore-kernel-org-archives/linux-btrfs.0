Return-Path: <SRS0=1Z4l=OC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE02C43441
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 15:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE9EB205C9
	for <linux-btrfs@archiver.kernel.org>; Fri, 23 Nov 2018 15:55:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE9EB205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440449AbeKXCk2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 23 Nov 2018 21:40:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:33784 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2440432AbeKXCk0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Nov 2018 21:40:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 00479AD9D;
        Fri, 23 Nov 2018 15:55:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 41F95DA858; Fri, 23 Nov 2018 16:55:23 +0100 (CET)
Date:   Fri, 23 Nov 2018 16:55:22 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/6] Delayed refs rsv
Message-ID: <20181123155521.GF2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20181121185912.24288-1-josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121185912.24288-1-josef@toxicpanda.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 21, 2018 at 01:59:06PM -0500, Josef Bacik wrote:
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

Parts of this cover letter could go to the main patch 5/6 to extend the
background why the change is made.

As the other patchsets build on top of this, I'll merge this to to
misc-next soon. The testing so far looks ok, some patches might need
fixups but nothing big that I can't do at commit time.

The patch 5/6 still seems too big, some parts could be split as
preparatory work, otherwise the main idea where to wire in the special
block reserve seems clear. If anybody wants to do a review there, please
do, I did only a high-level and did not check all the calculations etc.
