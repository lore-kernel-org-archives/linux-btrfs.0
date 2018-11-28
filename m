Return-Path: <SRS0=CI8N=OH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB14C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 18:10:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F5F2206B2
	for <linux-btrfs@archiver.kernel.org>; Wed, 28 Nov 2018 18:10:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3F5F2206B2
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725896AbeK2FM4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 29 Nov 2018 00:12:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:40948 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725760AbeK2FM4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 29 Nov 2018 00:12:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 52C05AF9C
        for <linux-btrfs@vger.kernel.org>; Wed, 28 Nov 2018 18:10:25 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 7537DDAC7F; Wed, 28 Nov 2018 19:10:08 +0100 (CET)
Date:   Wed, 28 Nov 2018 19:10:07 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2] btrfs: improve error handling of btrfs_add_link()
Message-ID: <20181128181007.GX2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Johannes Thumshirn <jthumshirn@suse.de>,
        David Sterba <dsterba@suse.com>,
        Linux BTRFS Mailinglist <linux-btrfs@vger.kernel.org>
References: <20181123084243.25899-1-jthumshirn@suse.de>
 <20181126183759.GJ2842@twin.jikos.cz>
 <880baf21-3b1f-cff9-c687-92bc8844547d@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <880baf21-3b1f-cff9-c687-92bc8844547d@suse.de>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 27, 2018 at 09:56:43AM +0100, Johannes Thumshirn wrote:
> On 26/11/2018 19:37, David Sterba wrote:
> > I though a transaction abort would be here, as the state is not
> > consistent. Also I'm not sure what I as a user would get from such error
> > message after calling link(). If the error handling in the error
> > handling fails, there's not much left to do and the abort either
> > happened earlier in the callees or is necessary here.
> 
> OK, now you've lost me. Isn't that what my previous patch did?

Yes (call abort in fail_dir_item:) but it also merged all the abort
calls -- this is the part that I wanted to be updated.
