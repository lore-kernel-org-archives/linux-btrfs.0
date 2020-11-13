Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752F7C388F7
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Nov 2020 16:12:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DF1C2076E
	for <linux-btrfs@archiver.kernel.org>; Fri, 13 Nov 2020 16:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726852AbgKMQMg (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 11:12:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:49890 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbgKMQMf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 13 Nov 2020 11:12:35 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id D44CEAE61;
        Fri, 13 Nov 2020 16:12:34 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id BBAFFDA87A; Fri, 13 Nov 2020 17:10:51 +0100 (CET)
Date:   Fri, 13 Nov 2020 17:10:51 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Daniel Xu <dxu@dxuuu.xyz>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH] btrfs: tree-checker: Error out if invalid
 btrfs_root_item size found
Message-ID: <20201113161051.GC6756@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Daniel Xu <dxu@dxuuu.xyz>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
References: <0e869ff2f4ace0acb4bcfcd9a6fcf95d95b1d85a.1605232441.git.dxu@dxuuu.xyz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e869ff2f4ace0acb4bcfcd9a6fcf95d95b1d85a.1605232441.git.dxu@dxuuu.xyz>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 12, 2020 at 05:55:06PM -0800, Daniel Xu wrote:
> There was a proper error check but it failed to error out. This can
> cause stack scribbling against a crafted iamge.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=210181
> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>

Added to misc-next, thanks.
