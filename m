Return-Path: <SRS0=aenA=QS=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 157C6C169C4
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 18:41:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0B3021B1C
	for <linux-btrfs@archiver.kernel.org>; Mon, 11 Feb 2019 18:41:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbfBKSlv (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 11 Feb 2019 13:41:51 -0500
Received: from mx2.suse.de ([195.135.220.15]:55604 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727850AbfBKSlv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 11 Feb 2019 13:41:51 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CC89EB138;
        Mon, 11 Feb 2019 18:41:49 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 81BDBDA84E; Mon, 11 Feb 2019 19:41:07 +0100 (CET)
Date:   Mon, 11 Feb 2019 19:41:07 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/5] btrfs: fix comment its device list mutex not
 volume lock
Message-ID: <20190211184107.GY2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <8bcd64cd-051e-f2b7-8687-b52303d8ad0f@suse.com>
 <1549611577-15478-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1549611577-15478-1-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 08, 2019 at 03:39:37PM +0800, Anand Jain wrote:
> We have killed volume mutex (commit: dccdb07bc996
> btrfs: kill btrfs_fs_info::volume_mutex). This a trival one seems to have
> escaped.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> v2: Delete the wrong comment instead of fixing it.

This patch has been added to misc-next, thanks.
