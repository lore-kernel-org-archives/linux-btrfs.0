Return-Path: <SRS0=qsaG=XE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19602C4740C
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Sep 2019 17:34:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE0E921924
	for <linux-btrfs@archiver.kernel.org>; Mon,  9 Sep 2019 17:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbfIIRex (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 9 Sep 2019 13:34:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:41076 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729559AbfIIRex (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Sep 2019 13:34:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 74917AD3C;
        Mon,  9 Sep 2019 17:34:51 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id CEA59DA97A; Mon,  9 Sep 2019 19:35:14 +0200 (CEST)
Date:   Mon, 9 Sep 2019 19:35:14 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Vladimir Panteleev <git@panteleev.md>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: mkfs: fix xattr enumeration
Message-ID: <20190909173514.GE2850@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Vladimir Panteleev <git@panteleev.md>,
        linux-btrfs@vger.kernel.org
References: <20190906095846.30592-1-git@vladimir.panteleev.md>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906095846.30592-1-git@vladimir.panteleev.md>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 06, 2019 at 09:58:46AM +0000, Vladimir Panteleev wrote:
> Use the return value of listxattr instead of tokenizing.
> 
> The end of the extended attribute list is indicated by the return
> value, not an empty list item (two consecutive NULs). Using strtok
> in this way thus sometimes caused add_xattr_item to reuse stack data
> in xattr_list from the previous invocation, thus querying attributes
> that are not actually in the file's xattr list.
> 
> Issue: #194
> Signed-off-by: Vladimir Panteleev <git@vladimir.panteleev.md>

Added to devel, thanks.
