Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B08CC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 00:04:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 268FC2082F
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 00:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731769AbfC0AEV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 26 Mar 2019 20:04:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:48730 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726782AbfC0AEV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Mar 2019 20:04:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id A1012B90D;
        Wed, 27 Mar 2019 00:04:19 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 74545DA8D8; Wed, 27 Mar 2019 00:55:39 +0100 (CET)
Date:   Wed, 27 Mar 2019 00:55:39 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Phillip Potter <phil@philpotter.co.uk>
Cc:     clm@fb.com, jbacik@fb.com, amir73il@gmail.com,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v6 07/07] btrfs: use common file type conversion
Message-ID: <20190326235539.GX10640@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Phillip Potter <phil@philpotter.co.uk>,
        clm@fb.com, jbacik@fb.com, amir73il@gmail.com,
        linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk
References: <20190326213934.GA20882@pathfinder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190326213934.GA20882@pathfinder>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Mar 26, 2019 at 09:39:34PM +0000, Phillip Potter wrote:
> Deduplicate the btrfs file type conversion implementation - file systems
> that use the same file types as defined by POSIX do not need to define
> their own versions and can use the common helper functions decared in
> fs_types.h and implemented in fs_types.c
> 
> Common implementation can be found via commit:
> bbe7449e2599 "fs: common implementation of file type"

Now that the prerequisite patch is in master, I can pick the btrfs
specific part. Thanks.
