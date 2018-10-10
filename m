Return-Path: <SRS0=ayZ+=MW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA92C43441
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 07:34:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4035A214DA
	for <linux-btrfs@archiver.kernel.org>; Wed, 10 Oct 2018 07:34:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4035A214DA
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbeJJOzk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 10 Oct 2018 10:55:40 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:50657 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726600AbeJJOzj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 Oct 2018 10:55:39 -0400
Received: from [192.168.1.7] (x5ce2d053.dyn.telefonica.de [92.226.208.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 00AD42012D0DC0;
        Wed, 10 Oct 2018 09:34:44 +0200 (CEST)
Subject: Re: [PATCH v3 0/2] btrfs: Add zstd support to grub btrfs
To:     Nick Terrell <terrelln@fb.com>
Cc:     grub-devel@gnu.org, Daniel Kiper <dkiper@net-space.pl>,
        kernel-team@fb.com, David Sterba <dsterba@suse.cz>,
        linux-btrfs@vger.kernel.org
References: <20181009232137.1941290-1-terrelln@fb.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <c00853f9-bc05-fe91-4e58-bf77f3da8583@molgen.mpg.de>
Date:   Wed, 10 Oct 2018 09:34:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20181009232137.1941290-1-terrelln@fb.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Dear Nick,


Thank you very much for your patches.


Am 10.10.2018 um 01:21 schrieb Nick Terrell:

> This patch set imports the upstream zstd library, adds zstd support to the
> btrfs module, and adds a test case. I've also tested the patch set by storing
> my boot partition in btrfs with and without zstd compression and rebooting.
> 
> The fist patch imports the files needed to support zstd decompression from
> zstd-1.3.6 as-is. It is a very large patch. In case it doesn't make it,
> I've included the commit hash and the script I used to download the files.
> 
> Upstream zstd commit hash: 4fa456d7f12f8b27bd3b2f5dfd4f46898cb31c24
> Upstream zstd commit name: Merge pull request #1354 from facebook/dev
> 
> ---
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

Sorry for being ignorant, but you explain, why the library needs to be 
imported and it is not enough to use that library as an external dependency?

Importing the library means, it has to be maintained in the GRUB 
repository, which will result in some maintenance burden.


Kind regards,

Paul
