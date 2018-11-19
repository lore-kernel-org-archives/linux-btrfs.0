Return-Path: <SRS0=YqDN=N6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E311C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 15:12:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DB32F20831
	for <linux-btrfs@archiver.kernel.org>; Mon, 19 Nov 2018 15:12:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DB32F20831
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbeKTBfz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 19 Nov 2018 20:35:55 -0500
Received: from dibed.net-space.pl ([84.10.22.86]:49447 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729548AbeKTBfz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 20:35:55 -0500
Received: from router-fw.i.net-space.pl ([192.168.52.1]:55096 "EHLO
        tomti.i.net-space.pl") by router-fw-old.i.net-space.pl with ESMTP
        id S1798336AbeKSPJR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Nov 2018 16:09:17 +0100
X-Comment: RFC 2476 MSA function at dibed.net-space.pl logged sender identity as: dkiper
Date:   Mon, 19 Nov 2018 16:09:15 +0100
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Nick Terrell <terrelln@fb.com>
Cc:     David Sterba <dsterba@suse.cz>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, grub-devel@gnu.org
Subject: Re: [PATCH v6 2/2] btrfs: Add zstd support to grub btrfs
Message-ID: <20181119150915.ktbaun6pu5uswgic@tomti.i.net-space.pl>
References: <20181115223603.3806542-1-terrelln@fb.com>
 <20181115223603.3806542-3-terrelln@fb.com>
 <20181119142251.xo3xmkbbpr6l22xu@tomti.i.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181119142251.xo3xmkbbpr6l22xu@tomti.i.net-space.pl>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 19, 2018 at 03:22:51PM +0100, Daniel Kiper wrote:
> On Thu, Nov 15, 2018 at 02:36:03PM -0800, Nick Terrell wrote:
> > - Adds zstd support to the btrfs module.
> > - Adds a test case for btrfs zstd support.
> > - Changes top_srcdir to srcdir in the btrfs module's lzo include
> >   following comments from Daniel Kiper about the zstd include.
> >
> > Tested on Ubuntu-18.04 with a btrfs /boot partition with and without zstd
> > compression. A test case was also added to the test suite that fails before
> > the patch, and passes after.
> >
> > Signed-off-by: Nick Terrell <terrelln@fb.com>
>
> Reviewed-by: Daniel Kiper <daniel.kiper@oracle.com>
>
> If there are no objections I will apply this patch series in a week or so.

Errr... I have just realized that there are two many spaces just at the
beginning of most lines. There should be 2 instead of 4. Please take
a look at currently existing functions. Anyway, I can fix this before
committing. However, if you could repost whole patch series that would
be much easier for me.

Daniel
