Return-Path: <SRS0=1LDH=ON=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF6EC04EB8
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 14:35:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DA0A620672
	for <linux-btrfs@archiver.kernel.org>; Tue,  4 Dec 2018 14:35:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DA0A620672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbeLDOfW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 4 Dec 2018 09:35:22 -0500
Received: from mx2.suse.de ([195.135.220.15]:52680 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726351AbeLDOfW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Dec 2018 09:35:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3D13EAD22;
        Tue,  4 Dec 2018 14:35:20 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 506FADAC39; Tue,  4 Dec 2018 15:35:00 +0100 (CET)
Date:   Tue, 4 Dec 2018 15:35:00 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc:     linux-btrfs@vger.kernel.org, nborisov@suse.com
Subject: Re: [PATCH v2 1/3] btrfs: remove always true if branch in
 find_delalloc_range
Message-ID: <20181204143500.GU17773@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, nborisov@suse.com
References: <20181128032130.11452-1-lufq.fnst@cn.fujitsu.com>
 <20181129033338.2647-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181129033338.2647-1-lufq.fnst@cn.fujitsu.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 29, 2018 at 11:33:38AM +0800, Lu Fengqi wrote:
> The @found is always false when it comes to the if branch. Besides, the
> bool type is more suitable for @found. Change the return value of the
> function and its caller to bool as well.
> 
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>

Added to misc-next, thanks.
