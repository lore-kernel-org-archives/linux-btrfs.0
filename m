Return-Path: <SRS0=cccy=PZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97DADC43387
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66476205C9
	for <linux-btrfs@archiver.kernel.org>; Thu, 17 Jan 2019 15:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbfAQP61 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 17 Jan 2019 10:58:27 -0500
Received: from mx2.suse.de ([195.135.220.15]:45340 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726854AbfAQP61 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Jan 2019 10:58:27 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 29EC2AC66;
        Thu, 17 Jan 2019 15:58:26 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id EE3FDDA83D; Thu, 17 Jan 2019 16:57:56 +0100 (CET)
Date:   Thu, 17 Jan 2019 16:57:56 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/6] btrfs: cleanup btrfs_find_device_by_devspec()
Message-ID: <20190117155756.GY2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
 <1547739153-6916-3-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547739153-6916-3-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Jan 17, 2019 at 11:32:29PM +0800, Anand Jain wrote:
> btrfs_find_device_by_devspec() finds the device by @devid or by
> @device_path. This patch makes code flow easy to read by open
> coding the else part and renames devpath to device_path.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> If the else is preferred, I am ok to keep them. Nikolay?

It looks better to me the way you implement it, a series of ifs, each
does a return, the function is short and easy to follow.

Reviewed-by: David Sterba <dsterba@suse.com>
