Return-Path: <SRS0=HUwI=TD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B00C4C43219
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 May 2019 09:39:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C299206DF
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 May 2019 09:39:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfECJju (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 3 May 2019 05:39:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:45480 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726047AbfECJju (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 May 2019 05:39:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E318AAEDB;
        Fri,  3 May 2019 09:39:48 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 618E8DA885; Fri,  3 May 2019 11:40:48 +0200 (CEST)
Date:   Fri, 3 May 2019 11:40:48 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Kimberly Brown <kimbrownkd@gmail.com>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: sysfs: Replace default_attrs in ktypes with groups
Message-ID: <20190503094047.GE20156@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Kimberly Brown <kimbrownkd@gmail.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190502173445.5308-1-kimbrownkd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502173445.5308-1-kimbrownkd@gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, May 02, 2019 at 01:34:45PM -0400, Kimberly Brown wrote:
> The kobj_type default_attrs field is being replaced by the
> default_groups field. Replace the default_attrs fields in
> btrfs_raid_ktype and space_info_ktype with default_groups.
> 
> Change "raid_attributes" to "raid_attrs", and use the ATTRIBUTE_GROUPS
> macro to create raid_groups and space_info_groups.
> 
> Signed-off-by: Kimberly Brown <kimbrownkd@gmail.com>

Acked-by: David Sterba <dsterba@suse.com>

> ---
> 
> This patch depends on a patch in the driver-core tree: https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git/commit/?h=driver-core-next&id=aa30f47cf666111f6bbfd15f290a27e8a7b9d854
> 
> GregKH can take this patch through the driver-core tree, or this patch
> can wait a release cycle and go through the subsystem's tree, whichever
> the subsystem maintainer is more comfortable with.

Please take it through the driver-core tree, thanks.
