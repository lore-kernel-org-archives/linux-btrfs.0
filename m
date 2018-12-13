Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AA9BC65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 16:45:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EECE620851
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 16:45:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EECE620851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbeLMQp2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 11:45:28 -0500
Received: from mx2.suse.de ([195.135.220.15]:40432 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727579AbeLMQp1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 11:45:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id BF9DBAE4B;
        Thu, 13 Dec 2018 16:45:16 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 1123FDA7EE; Thu, 13 Dec 2018 17:44:55 +0100 (CET)
Date:   Thu, 13 Dec 2018 17:44:54 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 08/10] btrfs: rework btrfs_check_space_for_delayed_refs
Message-ID: <20181213164454.GH23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <20181203152038.21388-1-josef@toxicpanda.com>
 <20181203152038.21388-9-josef@toxicpanda.com>
 <d1b3748c-3783-a57e-bf93-a92b5fd3806f@suse.com>
 <20181206175408.GB23615@twin.jikos.cz>
 <9fe84f0f-491a-1e63-e622-bb14282d5229@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9fe84f0f-491a-1e63-e622-bb14282d5229@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 07, 2018 at 09:09:28AM +0200, Nikolay Borisov wrote:
> 
> 
> On 6.12.18 г. 19:54 ч., David Sterba wrote:
> > On Thu, Dec 06, 2018 at 06:52:21PM +0200, Nikolay Borisov wrote:
> >>
> >>
> >> On 3.12.18 г. 17:20 ч., Josef Bacik wrote:
> >>> Now with the delayed_refs_rsv we can now know exactly how much pending
> >>> delayed refs space we need.  This means we can drastically simplify
> >>
> >> IMO it will be helpful if there is a sentence here referring back to
> >> btrfs_update_delayed_refs_rsv to put your first sentence into context.
> >> But I guess this is something David can also do.
> > 
> > I'll update the changelog, but I'm not sure what exactly you want to see
> > there, please post the replacement text. Thanks.
> 
> With the introduction of dealyed_refs_rsv infrastructure, namely
> btrfs_update_delayed_refs_rsv we now know exactly how much pending
> delayed refs space is required.

Changelog updated, thanks.
