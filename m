Return-Path: <SRS0=DppP=NM=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF18C0044C
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 18:54:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13B82205F4
	for <linux-btrfs@archiver.kernel.org>; Thu,  1 Nov 2018 18:54:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13B82205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727861AbeKBD6b (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 1 Nov 2018 23:58:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:54380 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727745AbeKBD6a (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 1 Nov 2018 23:58:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8D6F8AFB6
        for <linux-btrfs@vger.kernel.org>; Thu,  1 Nov 2018 18:54:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3181CDA6F4; Thu,  1 Nov 2018 19:54:06 +0100 (CET)
Date:   Thu, 1 Nov 2018 19:54:06 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 0/4] btrfs: Refactor find_free_extent()
Message-ID: <20181101185406.GV9136@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181017065606.8707-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181017065606.8707-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 17, 2018 at 02:56:02PM +0800, Qu Wenruo wrote:
> Can be fetched from github:
> https://github.com/adam900710/linux/tree/refactor_find_free_extent

Can you please rebase it again, on top of current misc-4.20? Ie. the 2nd
pull request. There were some fixes to the space infos, a new variable
added to find_free_extent (conflict in the 1st patch) that was easy to
fix, but further patches move code around and it was not a simple copy
as the variable would probably need to be added to the free space ctl.

This is a change beyond the level I'm confident doing during reabses and
don't want to introduce a bug to your code. This should be the last
rebase of this series. Things that are ready will go from topic branches
to misc-next after rc1 is out. Thanks for the help.
