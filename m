Return-Path: <SRS0=9zVn=MX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D63FFC677FC
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA96A20658
	for <linux-btrfs@archiver.kernel.org>; Thu, 11 Oct 2018 18:20:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA96A20658
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbeJLBsh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 11 Oct 2018 21:48:37 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:55360 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727443AbeJLBsh (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 21:48:37 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1874981AbeJKSPH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 11 Oct 2018 20:15:07 +0200
Date:   Thu, 11 Oct 2018 20:15:07 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     Nick Terrell <terrelln@fb.com>
Cc:     David Sterba <dsterba@suse.cz>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org, grub-devel@gnu.org,
        Daniel Kiper <dkiper@net-space.pl>, kreijack@inwind.it,
        kreijack@libero.it
Subject: Re: [PATCH v3 0/2] btrfs: Add zstd support to grub btrfs
Message-ID: <20181011181507.GG30679@router-fw-old.i.net-space.pl>
References: <20181009232137.1941290-1-terrelln@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181009232137.1941290-1-terrelln@fb.com>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Nick,

CC-ing Goffredo.

On Tue, Oct 09, 2018 at 04:21:35PM -0700, Nick Terrell wrote:
> Hi all,
>
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

In general I am happy with the patches. If everything is done what
I have asked for then I will get them. However, there is one problem.
Another big btrfs (RAID) patchset is lurking around for months. It is
almost ready. Goffredo, I am looking at you... So, I would like to take
RAID patchset first. If it is in the tree then I will ask you to rebase
zstd patchset on top of RAID patchset and I will take it. Nick, are you
OK with that?

Daniel
