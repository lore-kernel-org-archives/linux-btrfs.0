Return-Path: <SRS0=cNHg=PL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAACDC43387
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 14:45:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 838982070D
	for <linux-btrfs@archiver.kernel.org>; Thu,  3 Jan 2019 14:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726866AbfACOpD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 3 Jan 2019 09:45:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:59280 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726044AbfACOpD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Jan 2019 09:45:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 96B0EADFE
        for <linux-btrfs@vger.kernel.org>; Thu,  3 Jan 2019 14:45:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C9EAFDA781; Thu,  3 Jan 2019 15:44:32 +0100 (CET)
Date:   Thu, 3 Jan 2019 15:44:32 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/7] btrfs: Replace open-coded maths with DIV_ROUND_UP
Message-ID: <20190103144432.GH23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20190103085005.32053-1-nborisov@suse.com>
 <20190103085005.32053-7-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190103085005.32053-7-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 03, 2019 at 10:50:04AM +0200, Nikolay Borisov wrote:
> In a couple of places it's required to calculate the number of pages
> given a start and end offsets. Currently this is opencoded, unify the
> code base by replacing all such sites with the DIV_ROUND_UP macro. Also,
> current open-coded sites were buggy in that they were adding
> 'PAGE_SIZE', rather than 'PAGE_SIZE - 1'.

Didn't you find it strange that it's so consistently wrong? After a
closer inspection, you'd find that the end of the range is inclusive. So
the math is correct and your patch introduces a bug.

end - start + PAGE_SIZE = end + 1 - start + PAGE_SIZE - 1

Check eg. writepage_delalloc how it sets up page_end.

The correct use in DIV_ROUND_UP needs +1 adjustment.
