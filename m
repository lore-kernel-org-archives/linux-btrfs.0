Return-Path: <SRS0=mYd/=OF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BCA8C43441
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 16:18:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BF31205C9
	for <linux-btrfs@archiver.kernel.org>; Mon, 26 Nov 2018 16:18:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9BF31205C9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbeK0DNG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 26 Nov 2018 22:13:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:54558 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726343AbeK0DNG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Nov 2018 22:13:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9B742B063;
        Mon, 26 Nov 2018 16:18:30 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 2F460DAD8F; Mon, 26 Nov 2018 17:18:12 +0100 (CET)
Date:   Mon, 26 Nov 2018 17:18:12 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Subject: Re: [PATCH 00/10] btrfs-progs: my libbtrfsutil patch queue
Message-ID: <20181126161811.GH2842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
References: <cover.1542181521.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1542181521.git.osandov@fb.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Nov 13, 2018 at 11:46:55PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Hi,
> 
> This series contains my backlog of libbtrfsutil changes which I've been
> collecting over the past few weeks.
> 
> Patches 1-4 are fixes. Patches 5-6 add functionality to the unit tests
> which is needed for patches 7-8. Patches 7-8 add support for the
> unprivileged ioctls added in Linux 4.18; more on those below. Patch 9
> bumps the library version. Patch 10 adds documentation for the available
> API along with examples.
> 
> Patches 7-8 are based on Misono Tomohiro's previous patch series [1],
> with a few important changes.
> 
> - Both subvolume_info() and create_subvolume_iterator() now have unit
>   tests for the unprivileged case.
> - Both no longer explicitly check that top == 0 in the unprivileged
>   case, since that will already fail with a clear permission error.
> - Unprivileged iteration is much simpler: it uses openat() instead of
>   fchdir() and is based more closely on the original tree search
>   variant. This fixes a bug in post-order iteration in Misono's version.
> - Unprivileged iteration does _not_ support passing in a non-subvolume
>   path; if this behavior is desired, I'd like it to be a separate change
>   with an explicit flag.

Series merged to devel, thanks. I've added link from the main README now
that there's the API documentation.

The test-libbtrfsutil is missing from the travis CI for some reason, I
was about to add it.  So far the testing environment does not provide
'umount' that knows about '-R' so the tests fail. I'll have a look if
there's a newer base image provided, otherwise a workaround would be
necessary.

As for the unprivileged subvolume listing ioctls, the functionality in
the util library is self-contained and the interface is up to you to
design properly, so this does not depend on the 'btrfs subvolume list'
command. That one has unfortunately not bubbled high enough in my todo.
