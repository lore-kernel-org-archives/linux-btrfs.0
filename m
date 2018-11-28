Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E71EC43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 18:35:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28D87206B2
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 18:35:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28D87206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728496AbeK2FiN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 00:38:13 -0500
Received: from mx2.suse.de ([195.135.220.15]:43978 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725266AbeK2FiM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 00:38:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6E77FADE4;
        Wed, 28 Nov 2018 18:35:37 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 16D02DAC7F; Wed, 28 Nov 2018 19:35:19 +0100 (CET)
Date:   Wed, 28 Nov 2018 19:35:18 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org, josef@toxicpanda.com
Subject: Re: [PATCH] btrfs: Remove unnecessary code from __btrfs_rebalance
Message-ID: <20181128183517.GY2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org, josef@toxicpanda.com
References: <20181122081733.26082-1-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181122081733.26082-1-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 22, 2018 at 10:17:33AM +0200, Nikolay Borisov wrote:
> The first step fo the rebalance process, ensuring there is 1mb free on
> each device. This number seems rather small. And in fact when talking
> to the original authors their opinions were:
> 
> "man that's a little bonkers"
> "i don't think we even need that code anymore"
> "I think it was there to make sure we had room for the blank 1M at the
> beginning. I bet it goes all the way back to v0"
> "we just don't need any of that tho, i say we just delete it"
>
> Clearly, this piece of code has lost its original intent throughout
> the years. It doesn't really bring any real practical benefits to the
> relocation process.

That I would agree, 

> No functional changes.

though this sounds too bold given what code it removes. Shrink, grow in
a transaction, all of that can fail for various reasons and would have
visible effects. I'd rather reserve the 'no functional changes'
statement for cases where it's really just renaming or restructuring the
code without any side effects.

> -		ret = btrfs_shrink_device(device, old_size - size_to_free);
> -		if (ret == -ENOSPC)
> -			break;

Shrink can be pretty heavy even before it fails with ENOSPC, I think the
runtime of balance will go down. And it could be even noticeable, as it
has to go through all chunks twice before it really fails.

Measuring that would be good as it's a thing that can be a hilight of
pull request/change overviews.

I'll add the patch to for-next for testing, please update te changelog
with the potential effects. Thanks.
