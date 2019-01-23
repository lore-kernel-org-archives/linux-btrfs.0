Return-Path: <SRS0=0sRS=P7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7B08C282C0
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:48:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1D8121855
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Jan 2019 17:48:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfAWRsR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Jan 2019 12:48:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:39542 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725896AbfAWRsR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Jan 2019 12:48:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 77C56AF99
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Jan 2019 17:48:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 74AC7DA6F5; Wed, 23 Jan 2019 18:47:38 +0100 (CET)
Date:   Wed, 23 Jan 2019 18:47:37 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [Patch v5 0/7] btrfs: qgroup: Delay subtree scan to reduce
 overhead
Message-ID: <20190123174736.GW2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190123071518.2528-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190123071518.2528-1-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Jan 23, 2019 at 03:15:11PM +0800, Qu Wenruo wrote:
> v5:
> - Use Josef's superior qgroup deadlock fix.
>   No performance regression now.

Does this pass fstests on your side? Namely if test btrfs/007 does not
crash,
https://lore.kernel.org/linux-btrfs/20190123135120.GT2900@twin.jikos.cz/
