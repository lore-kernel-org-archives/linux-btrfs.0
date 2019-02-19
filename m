Return-Path: <SRS0=T+sm=Q2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF236C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 19:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 959F32147C
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Feb 2019 19:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729259AbfBSTDg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Feb 2019 14:03:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:51840 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726110AbfBSTDf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Feb 2019 14:03:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C68EFAEE8;
        Tue, 19 Feb 2019 19:03:33 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BC8FEDA83C; Tue, 19 Feb 2019 20:04:54 +0100 (CET)
Date:   Tue, 19 Feb 2019 20:04:51 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Chris Mason <clm@fb.com>, Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] btrfs: drop the lock on error in
 btrfs_dev_replace_cancel()
Message-ID: <20190219190451.GU9874@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dan Carpenter <dan.carpenter@oracle.com>,
        Chris Mason <clm@fb.com>, Anand Jain <anand.jain@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20190211183209.GA13934@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190211183209.GA13934@kadam>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Feb 11, 2019 at 09:32:10PM +0300, Dan Carpenter wrote:
> We should drop the lock on this error path.  This is from static
> analysis and I don't know if it's possible to hit this error path in
> real life.

Yes the lock needs to be released, it's there to protect access to the
dev_replace members and is not supposed to be left locked. The value of
state that's being switched would need to be artifically changed to an
invalid value so the default: branch is taken.

It's been introduced by d189dd70e25561817325 in 5.0-rc1 so it counts as
a regression but I don't think it's urgent enough to be sent to a late
rc. It'll go through the stable tree channel. Thanks.
