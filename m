Return-Path: <SRS0=OzA0=RC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D288C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 16:04:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DEA5217F5
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Feb 2019 16:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726810AbfB0QEE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Feb 2019 11:04:04 -0500
Received: from mx2.suse.de ([195.135.220.15]:51336 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726419AbfB0QED (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Feb 2019 11:04:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CDE24AE14;
        Wed, 27 Feb 2019 16:04:02 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 825ACDA83C; Wed, 27 Feb 2019 17:05:23 +0100 (CET)
Date:   Wed, 27 Feb 2019 17:05:23 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 03/10] btrfs: trivial, fix c coding style
Message-ID: <20190227160523.GS24609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1550857192-10513-1-git-send-email-anand.jain@oracle.com>
 <1550857192-10513-4-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1550857192-10513-4-git-send-email-anand.jain@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Feb 23, 2019 at 01:39:45AM +0800, Anand Jain wrote:
> Maintain the lines extented upto 80 char where possible, and indent the
> argument.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>

I don't think such patches are necessary, there's a lot of strange
formatting from the past and we could fix the ugly ones but otherwise
strive to fix everything before it gets merged.  I do a lot of fixups
just before the final merge, but having everybody follow the same coding
style is near to impossible.
