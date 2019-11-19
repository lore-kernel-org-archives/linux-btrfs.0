Return-Path: <SRS0=Px4L=ZL=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 482DEC432C0
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Nov 2019 10:58:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26AB820692
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Nov 2019 10:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbfKSK65 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Nov 2019 05:58:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:49012 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726170AbfKSK65 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Nov 2019 05:58:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8A345B2C3;
        Tue, 19 Nov 2019 10:58:55 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D3E68DAAC2; Tue, 19 Nov 2019 11:58:56 +0100 (CET)
Date:   Tue, 19 Nov 2019 11:58:56 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 05/15] btrfs: sysfs, move /sys/fs/btrfs/UUID related
 functions together
Message-ID: <20191119105856.GQ3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org
References: <20191118084656.3089-1-anand.jain@oracle.com>
 <20191118084656.3089-6-anand.jain@oracle.com>
 <8972a47c-2fcc-f980-8e76-a7dc945ee939@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8972a47c-2fcc-f980-8e76-a7dc945ee939@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 19, 2019 at 11:24:37AM +0200, Nikolay Borisov wrote:
> 
> 
> On 18.11.19 г. 10:46 ч., Anand Jain wrote:
> > No functional changes. Move functions to bring btrfs_sysfs_remove_fsid()
> > and btrfs_sysfs_add_fsid() and its related functions together.
> > 
> > Signed-off-by: Anand Jain <anand.jain@oracle.com>
> 
> 
> This seems like pointless code motion.

Yeah, unless there's some other reason to move the code, just plain
moves are not desired.
