Return-Path: <SRS0=OHkO=4B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68E1DC2BA83
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 13:12:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 443E6222C2
	for <linux-btrfs@archiver.kernel.org>; Thu, 13 Feb 2020 13:12:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729772AbgBMNMR (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 13 Feb 2020 08:12:17 -0500
Received: from mx2.suse.de ([195.135.220.15]:43290 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729557AbgBMNMR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Feb 2020 08:12:17 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9D706AF10;
        Thu, 13 Feb 2020 13:12:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 57C06DA7A6; Thu, 13 Feb 2020 14:12:01 +0100 (CET)
Date:   Thu, 13 Feb 2020 14:12:01 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix devid attribute name
Message-ID: <20200213131201.GP2902@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <20200212173523.GO2902@twin.jikos.cz>
 <1581583253-26814-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581583253-26814-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Feb 13, 2020 at 04:40:53PM +0800, Anand Jain wrote:
> It looks like one of the attribute was missed out while renaming the
> devid attribute. So fix it here.
> 
> Fixes: 668e48af7a94 (btrfs: sysfs, add devid/dev_state kobject and device
> attributes)
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> Hi David, There is one trivial item which also got messed up in this
> series, its about function renaming. Can we merge this in misc-next.

Yes, I noticed too, thanks for the patch.
