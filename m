Return-Path: <SRS0=o3FP=P2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DD3DC07EBF
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 17:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 648872087E
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 17:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728288AbfARRsE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Jan 2019 12:48:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:39264 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727940AbfARRsE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Jan 2019 12:48:04 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 6BE1BAF09;
        Fri, 18 Jan 2019 17:48:03 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BBFDEDA773; Fri, 18 Jan 2019 18:47:31 +0100 (CET)
Date:   Fri, 18 Jan 2019 18:47:30 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2 v14] btrfs: refactor btrfs_free_stale_devices() to
 get return value
Message-ID: <20190118174730.GE2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1546579914-14971-1-git-send-email-anand.jain@oracle.com>
 <1546579914-14971-3-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1546579914-14971-3-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 04, 2019 at 01:31:53PM +0800, Anand Jain wrote:
> Preparatory patch to add forget cli.
> 
> Re-factors btrfs_free_stale_devices() to obtain return status. As
> this function can fail if it can't find the given path (returns -ENOENT)
> or trying to delete a mounted device (returns -EBUSY).
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---

Reviewed-by: David Sterba <dsterba@suse.com>

I've added this patch to the other device-related cleanups sent recently.
