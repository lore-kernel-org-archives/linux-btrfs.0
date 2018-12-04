Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85286C04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 13:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 254CA20659
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 13:53:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 254CA20659
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbeLDNxR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 08:53:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:44416 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726250AbeLDNxQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 08:53:16 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C4FF2B0FC;
        Tue,  4 Dec 2018 13:53:13 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 008EEDAC39; Tue,  4 Dec 2018 14:52:53 +0100 (CET)
Date:   Tue, 4 Dec 2018 14:52:53 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, stable@vger.kernel.org
Subject: Re: [PATCH] btrfs: tree-checker: Don't check max block group size as
 current max chunk size limit is unreliable
Message-ID: <20181204135253.GR17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
References: <20181123010636.19363-1-wqu@suse.com>
 <3cd7ba2f-377f-604e-5996-fbf5086b9843@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3cd7ba2f-377f-604e-5996-fbf5086b9843@gmx.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Dec 04, 2018 at 06:15:13PM +0800, Qu Wenruo wrote:
> Gentle ping.
> 
> Please put this patch into current release as the new block group size
> limit check introduced in v4.19 is causing at least 2 reports in mail list.

BTW, if there's an urgent fix or patch that should be considered for
current devel cycle, please note that in the subject like

  [PATCH for 4.20-rc] btrfs: ...

to make it more visible.
