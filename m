Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34716 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752330AbdLLVOK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 16:14:10 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A4520AFA0
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Dec 2017 21:14:09 +0000 (UTC)
Date: Tue, 12 Dec 2017 22:12:09 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, jeffm@suse.com
Subject: Re: [PATCH 00/14] Qgroup metadata reservation rework
Message-ID: <20171212211209.GB3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171212073436.16447-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171212073436.16447-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 12, 2017 at 03:34:22PM +0800, Qu Wenruo wrote:
> The patch is consist of 2 main parts:
> 1) Type based qgroup reservation
>    The original patchset is sent several months ago.
>    Nothing is modified at all, just rebased. And not conflict at all.
> 
>    It's from patch 1 to patch 6.
> 
> 2) Split meta qgroup reservation into per-trans and prealloc sub types
>    The real work to address metadata underflow.
>    Due to the over-reserve problem, this part is still in RFC state.
>    But the framework should mostly be fine, only needs extra fine-tuning
>    to get more accurate qgroup rsv to avoid too early limit.
> 
>    It's from patch 7 to 14.

I'm going to add the whole patchset to next, the first part has been
there for some time and no test failures were reported. I optimistically
expect that the second part will also be fine. However I'm not sure how
good is the test coverage of qgroups in fstests, so lack of reports may
not mean anything.
