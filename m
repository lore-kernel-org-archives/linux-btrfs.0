Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2281C677FF
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 17:31:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 99B1C2075B
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 17:31:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99B1C2075B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbeJLA7d (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 20:59:33 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:55270 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbeJLA7d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 20:59:33 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1874711AbeJKRbK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 19:31:10 +0200
Date:   Thu, 11 Oct 2018 19:31:10 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Nick Terrell <terrelln@fb.com>
Cc:     David Sterba <dsterba@suse.cz>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, grub-devel@gnu.org,
        Daniel Kiper <dkiper@net-space.pl>
Subject: Re: [PATCH v3 1/2] Import upstream zstd-1.3.6
Message-ID: <20181011173110.GE30679@router-fw-old.i.net-space.pl>
References: <20181009232137.1941290-1-terrelln@fb.com> <20181009232137.1941290-2-terrelln@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181009232137.1941290-2-terrelln@fb.com>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Oct 09, 2018 at 04:21:36PM -0700, Nick Terrell wrote:
> Import zstd-1.3.6 from upstream [1]. Only the files need for decompression
> are imported.
>
> I used the latest zstd release, which includes patches [2] to build cleanly
> in GRUB.
>
> Upstream zstd commit hash: 4fa456d7f12f8b27bd3b2f5dfd4f46898cb31c24
> Upstream zstd commit name: Merge pull request #1354 from facebook/dev
>
> I've included the script used to import zstd-1.3.6 below.
>
> [1] https://github.com/facebook/zstd/releases/tag/v1.3.6
> [2] https://github.com/facebook/zstd/pull/1344
>
> ---

I think that you should replace the dashes with something different
here. Otherwise "git am" may tear off the rest of commit message
starting from here.

> #!/bin/sh -e
>
> curl -L -O https://github.com/facebook/zstd/releases/download/v1.3.6/zstd-1.3.6.tar.gz
> curl -L -O https://github.com/facebook/zstd/releases/download/v1.3.6/zstd-1.3.6.tar.gz.sha256
> sha256sum --check zstd-1.3.6.tar.gz.sha256
> tar xzf zstd-1.3.6.tar.gz
>
> SRC_LIB="zstd-1.3.6/lib"
> DST_LIB="grub-core/lib/zstd"
> rm -rf $DST_LIB
> mkdir -p $DST_LIB
> cp $SRC_LIB/zstd.h $DST_LIB/
> cp $SRC_LIB/common/*.[hc] $DST_LIB/
> cp $SRC_LIB/decompress/*.[hc] $DST_LIB/
> rm $DST_LIB/{pool.[hc],threading.[hc]}
> rm -rf zstd-1.3.6*
> echo SUCCESS!
> ---

Ditto.

> Signed-off-by: Nick Terrell <terrelln@fb.com>

If you fix things above you can add
  Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>

Daniel
