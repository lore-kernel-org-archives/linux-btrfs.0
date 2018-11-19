Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CC8C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 14:29:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 314B920870
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 14:29:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 314B920870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbeKTAx3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 19:53:29 -0500
Received: from dibed.net-space.pl ([84.10.22.86]:49365 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728291AbeKTAx3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 19:53:29 -0500
Received: from router-fw.i.net-space.pl ([192.168.52.1]:55084 "EHLO
        tomti.i.net-space.pl") by router-fw-old.i.net-space.pl with ESMTP
        id S1880927AbeKSOWz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 15:22:55 +0100
X-Comment: RFC 2476 MSA function at dibed.net-space.pl logged sender identity as: dkiper
Date:   Mon, 19 Nov 2018 15:22:51 +0100
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Nick Terrell <terrelln@fb.com>
Cc:     David Sterba <dsterba@suse.cz>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, grub-devel@gnu.org
Subject: Re: [PATCH v6 2/2] btrfs: Add zstd support to grub btrfs
Message-ID: <20181119142251.xo3xmkbbpr6l22xu@tomti.i.net-space.pl>
References: <20181115223603.3806542-1-terrelln@fb.com>
 <20181115223603.3806542-3-terrelln@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181115223603.3806542-3-terrelln@fb.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Thu, Nov 15, 2018 at 02:36:03PM -0800, Nick Terrell wrote:
> - Adds zstd support to the btrfs module.
> - Adds a test case for btrfs zstd support.
> - Changes top_srcdir to srcdir in the btrfs module's lzo include
>   following comments from Daniel Kiper about the zstd include.
>
> Tested on Ubuntu-18.04 with a btrfs /boot partition with and without zstd
> compression. A test case was also added to the test suite that fails before
> the patch, and passes after.
>
> Signed-off-by: Nick Terrell <terrelln@fb.com>

Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>

If there are no objections I will apply this patch series in a week or so.

Daniel
