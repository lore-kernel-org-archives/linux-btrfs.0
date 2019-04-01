Return-Path: <SRS0=hUT/=SD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F21BC43381
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 14:30:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9FFD20883
	for <linux-btrfs@archiver.kernel.org>; Mon,  1 Apr 2019 14:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbfDAOau (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 1 Apr 2019 10:30:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:42766 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726882AbfDAOau (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 1 Apr 2019 10:30:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 7CC92AF95;
        Mon,  1 Apr 2019 14:30:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 65E5EDA823; Mon,  1 Apr 2019 16:31:59 +0200 (CEST)
Date:   Mon, 1 Apr 2019 16:31:58 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: drop unused arg in mount_subvol
Message-ID: <20190401143158.GW29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1553839397-26941-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1553839397-26941-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 29, 2019 at 02:03:17PM +0800, Anand Jain wrote:
> @device_name in mount_subvol() is not used, drop it.
> Also see:
> 5bedc48a8f9e1d62fb693c4171ffddb990d034f6
> btrfs: drop unused parameters from mount_subvol
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.com>
