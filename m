Return-Path: <SRS0=yZnd=N7=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B974CC04EBC
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 13:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C6D220851
	for <linux-btrfs@archiver.kernel.org>; Tue, 20 Nov 2018 13:29:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C6D220851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbeKTX65 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 20 Nov 2018 18:58:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:52030 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725898AbeKTX65 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Nov 2018 18:58:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 81148AE7A;
        Tue, 20 Nov 2018 13:29:47 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 6193EDA8A7; Tue, 20 Nov 2018 14:29:28 +0100 (CET)
Date:   Tue, 20 Nov 2018 14:29:27 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RESEND v2 1/2] btrfs: quieten warn if replace is canceled
 at finish
Message-ID: <20181120132927.GI24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1542714976-28502-1-git-send-email-anand.jain@oracle.com>
 <1542714976-28502-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1542714976-28502-2-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 20, 2018 at 07:56:15PM +0800, Anand Jain wrote:
> When we successfully cancel the replace its scrub returns -ECANCELED,
> which then passed to btrfs_dev_replace_finishing(), it cleans up based
> on the scrub returned status and propagates the same -ECANCELED back
> the parent function. As of now only user can cancel the replace-scrub,
> so its ok to quieten the warn here.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Ok for getting rid if the ECANCELED warning, though it would be better
to replace the WARN_ON too.

Reviewed-by: David Sterba <dsterba@suse.com>
