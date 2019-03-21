Return-Path: <SRS0=tkEE=RY=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61632C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 13:18:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3303C218FF
	for <linux-btrfs@archiver.kernel.org>; Thu, 21 Mar 2019 13:18:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728271AbfCUNSG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 21 Mar 2019 09:18:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:58226 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728113AbfCUNSG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Mar 2019 09:18:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 70814AF2F
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2019 13:18:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 58499DA8A7; Thu, 21 Mar 2019 14:19:20 +0100 (CET)
Date:   Thu, 21 Mar 2019 14:19:20 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v5.3 07/11] btrfs: extent_io: Handle error better in
 extent_write_locked_range()
Message-ID: <20190321131920.GB26179@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190320062749.30953-1-wqu@suse.com>
 <20190320062749.30953-8-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190320062749.30953-8-wqu@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 20, 2019 at 02:27:45PM +0800, Qu Wenruo wrote:
> Do proper cleanup if we hit any error in extent_write_locked_range(),
> and check the return value of flush_write_bio().

Yes that's what the code does, but the changelog should explain why this
is correct. Same for "btrfs: extent_io: Handle error better in
extent_writepages()". You do that in other patches, why not in this one
too? If the reason is same for several patches, then copy it, eg. btrfs:
"extent_io: Handle errors better in btree_write_cache_pages()" is ok.

But don't resend, I'll fix it here as I made some other fixups to
changelogs and am finishing the whole series.
