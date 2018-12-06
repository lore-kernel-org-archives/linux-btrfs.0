Return-Path: <SRS0=+YL1=OP=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B61CC04EB8
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 17:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CECE820878
	for <linux-btrfs@archiver.kernel.org>; Thu,  6 Dec 2018 17:54:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CECE820878
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbeLFRye (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 6 Dec 2018 12:54:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:43990 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725901AbeLFRye (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 6 Dec 2018 12:54:34 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D7AE8AD88;
        Thu,  6 Dec 2018 17:54:32 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 5C35ADAB92; Thu,  6 Dec 2018 18:54:10 +0100 (CET)
Date:   Thu, 6 Dec 2018 18:54:08 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 08/10] btrfs: rework btrfs_check_space_for_delayed_refs
Message-ID: <20181206175408.GB23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20181203152038.21388-1-josef@toxicpanda.com>
 <20181203152038.21388-9-josef@toxicpanda.com>
 <d1b3748c-3783-a57e-bf93-a92b5fd3806f@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d1b3748c-3783-a57e-bf93-a92b5fd3806f@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 06, 2018 at 06:52:21PM +0200, Nikolay Borisov wrote:
> 
> 
> On 3.12.18 г. 17:20 ч., Josef Bacik wrote:
> > Now with the delayed_refs_rsv we can now know exactly how much pending
> > delayed refs space we need.  This means we can drastically simplify
> 
> IMO it will be helpful if there is a sentence here referring back to
> btrfs_update_delayed_refs_rsv to put your first sentence into context.
> But I guess this is something David can also do.

I'll update the changelog, but I'm not sure what exactly you want to see
there, please post the replacement text. Thanks.

> > btrfs_check_space_for_delayed_refs by simply checking how much space we
> > have reserved for the global rsv (which acts as a spill over buffer) and
> > the delayed refs rsv.  If our total size is beyond that amount then we
> > know it's time to commit the transaction and stop any more delayed refs
> > from being generated.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
