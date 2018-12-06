Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F35C04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 19:35:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82E4520672
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 19:35:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82E4520672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbeLFTfe (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 14:35:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:56984 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725948AbeLFTfd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 14:35:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4C39CADF2
        for <linux-btrfs@vger.kernel.org>; Thu,  6 Dec 2018 19:35:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 89317DAB92; Thu,  6 Dec 2018 20:35:12 +0100 (CET)
Date:   Thu, 6 Dec 2018 20:35:11 +0100
From:   David Sterba <dsterba@suse.cz>
To:     dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 0/6] btrfs: qgroup: Delay subtree scan to reduce
 overhead
Message-ID: <20181206193511.GF23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181108054919.18253-1-wqu@suse.com>
 <20181112213332.GS24115@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181112213332.GS24115@twin.jikos.cz>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 12, 2018 at 10:33:33PM +0100, David Sterba wrote:
> On Thu, Nov 08, 2018 at 01:49:12PM +0800, Qu Wenruo wrote:
> > This patchset can be fetched from github:
> > https://github.com/adam900710/linux/tree/qgroup_delayed_subtree_rebased
> > 
> > Which is based on v4.20-rc1.
> 
> Thanks, I'll add it to for-next soon.

The branch was there for some time but not for at least a week (my
mistake I did not notice in time). I've rebased it on top of recent
misc-next, but without the delayed refs patchset from Josef.

At the moment I'm considering it for merge to 4.21, there's still some
time to pull it out in case it shows up to be too problematic. I'm
mostly worried about the unknown interactions with the enospc updates or
generally because of lack of qgroup and reloc code reviews.

I'm going to do some testing of the rebased branch before I add it to
for-next. The branch is ext/qu/qgroup-delay-scan in my devel repos,
plase check if everyghing is still ok there. Thanks.
