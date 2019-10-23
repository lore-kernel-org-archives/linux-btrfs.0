Return-Path: <SRS0=avBk=YQ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5D70CA9EB6
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Oct 2019 17:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A23E421925
	for <linux-btrfs@archiver.kernel.org>; Wed, 23 Oct 2019 17:07:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbfJWRHa (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 23 Oct 2019 13:07:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:35486 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727638AbfJWRHa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 23 Oct 2019 13:07:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EC156AF10;
        Wed, 23 Oct 2019 17:07:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 8E2C6DA734; Wed, 23 Oct 2019 19:07:40 +0200 (CEST)
Date:   Wed, 23 Oct 2019 19:07:40 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Julien_N <noblet_julien@orange.fr>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: build: add missing symbols to libbtrfs -
 new patch
Message-ID: <20191023170740.GD3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Julien_N <noblet_julien@orange.fr>,
        linux-btrfs@vger.kernel.org
References: <3c3f25e4-7f36-b1f3-0e82-9745e0eb84cb@orange.fr>
 <41f818a8-a359-a21a-6490-94ce1cbfe16a@orange.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <41f818a8-a359-a21a-6490-94ce1cbfe16a@orange.fr>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 23, 2019 at 05:44:32PM +0200, Julien_N wrote:
> After testing with ldd tool, there is some other stuff to add:
> 
> (please apply those 2 patchs)

Thanks. While this fixes the compilation, the new object files define
new public symbols in libbtrfs and that requires version bump of the
version (at least, or use .sym definition).

The state of libbtrfs is reaching point where we should deprecate it and
enhance libbtrfsutil to provide all the functinonality as this is a
proper library. Unlike libbtrfs.

Snapper needs are covered only partially, the stream dumping is not
there, qgroup and random other things I checked are in the API.

New symbols in a library should be fine with a minor version bump,
so that's probably going to be the sufficient fix for now.
