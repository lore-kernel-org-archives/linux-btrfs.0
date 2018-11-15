Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B946C43441
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 14:00:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 641192083E
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 14:00:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 641192083E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732953AbeKPAIi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 19:08:38 -0500
Received: from mx2.suse.de ([195.135.220.15]:39696 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729034AbeKPAIi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 19:08:38 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 4B579AFE4;
        Thu, 15 Nov 2018 14:00:39 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 973B2DAC4A; Thu, 15 Nov 2018 15:00:22 +0100 (CET)
Date:   Thu, 15 Nov 2018 15:00:21 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/9] btrfs: fix UAF due to race between replace start and
 cancel
Message-ID: <20181115140021.GQ24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
 <1541946144-8174-5-git-send-email-anand.jain@oracle.com>
 <20181113172448.GF24115@twin.jikos.cz>
 <e1e32e53-3860-1d74-c2ed-1b4dbdb57404@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e1e32e53-3860-1d74-c2ed-1b4dbdb57404@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 14, 2018 at 09:28:34AM +0800, Anand Jain wrote:
> >>   	mutex_unlock(&dev_replace->lock_finishing_cancel_unmount);
> >>   	return result;
> > 
> > There's a compiler warning:
> > 
> > fs/btrfs/dev-replace.c: In function ‘btrfs_dev_replace_cancel’:
> > fs/btrfs/dev-replace.c:865:9: warning: ‘result’ may be used uninitialized in this function [-Wmaybe-uninitialized]
> >    return result;
> >           ^~~~~~
> 
> > I haven't looked closer though it looks valid.
> 
> int result; is assigned within switch(), so there isn't actual problem. 

The warning is there because switch (dev_replace->replace_state) does
not have a default: case that would catch the values outside of what's
defined by the enum. So in that case result would have undefined value.

> But will initialize the result to -EINVAL to quite the compiler.
> Sending v3.

I don't see any change in the followup version.
https://patchwork.kernel.org/patch/10681939/
