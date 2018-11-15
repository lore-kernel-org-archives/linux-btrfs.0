Return-Path: <SRS0=Mirb=N2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6684BC43610
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 15:31:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38E30223CB
	for <linux-btrfs@archiver.kernel.org>; Thu, 15 Nov 2018 15:31:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 38E30223CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388519AbeKPBkA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 15 Nov 2018 20:40:00 -0500
Received: from mx2.suse.de ([195.135.220.15]:54190 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726432AbeKPBj7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Nov 2018 20:39:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 73634AEA1;
        Thu, 15 Nov 2018 15:31:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 56DAFDAC4A; Thu, 15 Nov 2018 16:31:24 +0100 (CET)
Date:   Thu, 15 Nov 2018 16:31:24 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 8/9] btrfs: user requsted replace cancel is not an error
Message-ID: <20181115153124.GT24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1541946144-8174-1-git-send-email-anand.jain@oracle.com>
 <1541946144-8174-9-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1541946144-8174-9-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Nov 11, 2018 at 10:22:23PM +0800, Anand Jain wrote:
> As of now only user requested replace cancel can cancel the replace-scrub
> so no need to log error for it.

This has probably some user visible effect or threre are steps to
reproduce the message even if it's not expected (ie. the case that this
patch fixes). Please update the changelog, thanks.
