Return-Path: <SRS0=mSoy=M4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B26AC169D4
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 10:20:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEF942086E
	for <linux-btrfs@archiver.kernel.org>; Tue, 16 Oct 2018 10:20:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CEF942086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbeJPSKA (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 16 Oct 2018 14:10:00 -0400
Received: from mx2.suse.de ([195.135.220.15]:55648 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727076AbeJPSJ7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 Oct 2018 14:09:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0A9A3B084;
        Tue, 16 Oct 2018 10:20:15 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 14466DAD56; Tue, 16 Oct 2018 12:20:10 +0200 (CEST)
Date:   Tue, 16 Oct 2018 12:20:09 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org
Subject: Re: [PATCH v7 1/6] mm: split SWP_FILE into SWP_ACTIVATED and SWP_FS
Message-ID: <20181016102009.GA29418@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz,
        Andrew Morton <akpm@linux-foundation.org>,
        Omar Sandoval <osandov@osandov.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, linux-mm@kvack.org
References: <cover.1536704650.git.osandov@fb.com>
 <6d63d8668c4287a4f6d203d65696e96f80abdfc7.1536704650.git.osandov@fb.com>
 <20181012135934.b8dbbaaf8a01011ec21b5aba@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181012135934.b8dbbaaf8a01011ec21b5aba@linux-foundation.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Oct 12, 2018 at 01:59:34PM -0700, Andrew Morton wrote:
> On Tue, 11 Sep 2018 15:34:44 -0700 Omar Sandoval <osandov@osandov.com> wrote:
> 
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > The SWP_FILE flag serves two purposes: to make swap_{read,write}page()
> > go through the filesystem, and to make swapoff() call
> > ->swap_deactivate(). For Btrfs, we want the latter but not the former,
> > so split this flag into two. This makes us always call
> > ->swap_deactivate() if ->swap_activate() succeeded, not just if it
> > didn't add any swap extents itself.
> > 
> > This also resolves the issue of the very misleading name of SWP_FILE,
> > which is only used for swap files over NFS.
> > 
> 
> Acked-by: Andrew Morton <akpm@linux-foundation.org>

Andrew, can you please take the two patches through the mm tree? I'm not
going to send the btrfs swap patches in the upcoming merge window so it
would not make sense to add plain MM changes to btrfs tree.  The whole
series has been in linux-next for some time so it's just moving between
trees. Thanks.
