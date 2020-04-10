Return-Path: <SRS0=bDrN=52=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7380C2BB1D
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Apr 2020 16:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99FF220769
	for <linux-btrfs@archiver.kernel.org>; Fri, 10 Apr 2020 16:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgDJQqN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 10 Apr 2020 12:46:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:55786 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgDJQqN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 10 Apr 2020 12:46:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 00588AB64;
        Fri, 10 Apr 2020 16:46:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9BE3ADA72D; Fri, 10 Apr 2020 18:45:33 +0200 (CEST)
Date:   Fri, 10 Apr 2020 18:45:33 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: [PATCH] btrfs: re-instantiate the removed
 BTRFS_SUBVOL_CREATE_ASYNC definition
Message-ID: <20200410164533.GP5920@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Eugene Syromiatnikov <esyr@redhat.com>,
        linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>,
        Nikolay Borisov <nborisov@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Chris Mason <clm@fb.com>,
        "Dmitry V. Levin" <ldv@altlinux.org>
References: <20200401032650.GA24378@asgard.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200401032650.GA24378@asgard.redhat.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Apr 01, 2020 at 05:26:50AM +0200, Eugene Syromiatnikov wrote:
> The commit 9c1036fdb1d1ff1b ("btrfs: Remove BTRFS_SUBVOL_CREATE_ASYNC
> support") breaks strace build with the kernel headers from git:
> 
>     btrfs.c: In function "btrfs_test_subvol_ioctls":
>     btrfs.c:531:23: error: "BTRFS_SUBVOL_CREATE_ASYNC" undeclared (first use
>     in this function)
>        vol_args_v2.flags = BTRFS_SUBVOL_CREATE_ASYNC;
> 
> Moreover, it is improper to break UAPI anyway.

IIRC the reason for the UAPI exports was to let strace use the includes
to decode the ioctls, so for that I agree it's improper to break the
build, sorry. The ioctls are a public interface so it's an ABI.  Patch
added to 5.7 queue, thanks.
