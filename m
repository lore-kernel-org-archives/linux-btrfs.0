Return-Path: <SRS0=YGKe=NF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B0FCC46475
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 16:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DDC982083E
	for <linux-btrfs@archiver.kernel.org>; Thu, 25 Oct 2018 16:39:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DDC982083E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbeJZBMj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 25 Oct 2018 21:12:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:44300 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727363AbeJZBMj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Oct 2018 21:12:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B206EAD90
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Oct 2018 16:39:04 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DA3C9DA781; Thu, 25 Oct 2018 18:38:55 +0200 (CEST)
Date:   Thu, 25 Oct 2018 18:38:54 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/2] btrfstune fs_info cleanups
Message-ID: <20181025163854.GH16290@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
References: <1534771685-4924-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1534771685-4924-1-git-send-email-nborisov@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Aug 20, 2018 at 04:28:03PM +0300, Nikolay Borisov wrote:
> While inspecting btrfstune source code I came across 2 functions which needlessly
> take fs_info argument. This small series rectifies this. No functional changes. 
> 
> Nikolay Borisov (2):
>   btrfstune: Remove fs_info arg from change_device_uuid
>   btrfstune: Rename change_header_uuid to change_buffer_header_uuid

Applied, thanks.
