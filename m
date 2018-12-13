Return-Path: <SRS0=1olR=OW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F028C65BAE
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 18:41:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FF8D20851
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Dec 2018 18:41:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FF8D20851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbeLMSlb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Dec 2018 13:41:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:59278 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726448AbeLMSlb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Dec 2018 13:41:31 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7AB84AFF2;
        Thu, 13 Dec 2018 18:41:29 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id C1F08DA7EE; Thu, 13 Dec 2018 19:41:06 +0100 (CET)
Date:   Thu, 13 Dec 2018 19:41:06 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 0/8][V2] Enospc cleanups and fixeS
Message-ID: <20181213184106.GK23615@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Josef Bacik <josef@toxicpanda.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <20181203152459.21630-1-josef@toxicpanda.com>
 <20181213141111.GC23615@twin.jikos.cz>
 <20181213144554.pec3brfojs53smiv@macbook-pro-91.dhcp.thefacebook.com>
 <20181213181741.GJ23615@twin.jikos.cz>
 <20181213182850.qyyaegqzc5qijodx@MacBook-Pro-91.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181213182850.qyyaegqzc5qijodx@MacBook-Pro-91.local>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Dec 13, 2018 at 01:28:52PM -0500, Josef Bacik wrote:
> I mean I hit this ASSERT() in testing, and this patch series has the fixed patch
> 
> https://patchwork.kernel.org/patch/10709829/
> 
> this is what fixes the problem that is causing the ASSERT(), it appears your
> next branch doesn't have this updated patch, but the previous one which trips
> that ASSERT.  Thanks,

Ok found it, patch updated, thanks. No other related diff between the
topic branch vs branch with patches appleid from mail.
