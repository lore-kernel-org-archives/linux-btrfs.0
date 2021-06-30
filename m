Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 342D8C11F65
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jun 2021 13:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A0AC6143C
	for <linux-btrfs@archiver.kernel.org>; Wed, 30 Jun 2021 13:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhF3NPK (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 30 Jun 2021 09:15:10 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:59300 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234685AbhF3NPK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 30 Jun 2021 09:15:10 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 10EB51FE91;
        Wed, 30 Jun 2021 13:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1625058761;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LikIEmZFfYLEv2zAP7NnGZOkjRA8/dyZMp7zUkDORH4=;
        b=Ijf3ya/+EMKjUfQY+lm0IKqjifsi2yQdq7rjvCh9EHJLfAzqTHSYtA9N95vnm0Lkrq7zDh
        H/ydA9XCOeF4V3mmFK1w1ghdk45zzGD2tYTAFmkw9NtCm+eLwVW1aWQDexXTE2rQj8Mgco
        I378hO3smBcZVKA4O1MD8c9dvU2dpEg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1625058761;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LikIEmZFfYLEv2zAP7NnGZOkjRA8/dyZMp7zUkDORH4=;
        b=7TbH3LzHglNUoLJEzkSK2fQPF/hsjNJL85TianwzqKqytJZSsC7CXRkkJrEICSv0FTNQ8G
        rfZXRHIuqAGWpbDA==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id D6A71A3B85;
        Wed, 30 Jun 2021 13:12:40 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DA253DA7A2; Wed, 30 Jun 2021 15:10:10 +0200 (CEST)
Date:   Wed, 30 Jun 2021 15:10:10 +0200
From:   David Sterba <dsterba@suse.cz>
To:     fdmanana@kernel.org
Cc:     linux-btrfs@vger.kernel.org, naohiro.aota@wdc.com,
        Filipe Manana <fdmanana@suse.com>
Subject: Re: [PATCH 0/2] btrfs: eliminate a deadlock when allocating system
 chunks and rework chunk allocation
Message-ID: <20210630131010.GL2610@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, fdmanana@kernel.org,
        linux-btrfs@vger.kernel.org, naohiro.aota@wdc.com,
        Filipe Manana <fdmanana@suse.com>
References: <cover.1624973480.git.fdmanana@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1624973480.git.fdmanana@suse.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Jun 29, 2021 at 02:43:04PM +0100, fdmanana@kernel.org wrote:
> From: Filipe Manana <fdmanana@suse.com>
> 
> The first patch eliminates a deadlock when multiple tasks need to allocate
> a system chunk. It reverts a previous fix for a problem that resulted in
> exhausting the system chunk array and result in a transaction abort when
> there are many tasks allocating chunks in parallel. Since there is not a
> simple and short fix for the deadlock that does not bring back the system
> array exhaustion problem, and the deadlock is relatively easy to trigger
> on zoned filesystem while the exhaustion problem is not so common, this
> first patch just revets that previous fix.
> 
> The second patch reworks a bit of the chunk allocation code so that we
> don't hold onto reserved system space from phase 1 to phase 2 of chunk
> allocation, which is what leads to system chunk array exhaustion when
> there's a bunch of tasks doing chunks allocations in parallel (initially
> observed on PowerPC, with a 64K node size, when running the fallocate
> tests from stress-ng). The diff of this patch is quite big, but about
> half of it are just comments.

The description of the chunk allocation process is great, thanks.
Patches added to misc-next.
