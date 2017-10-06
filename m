Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47787 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751491AbdJFQyY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Oct 2017 12:54:24 -0400
Date: Fri, 6 Oct 2017 18:52:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] btrfs-progs: check: original and lowmem mode fix
Message-ID: <20171006165239.GV3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170927063440.25961-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170927063440.25961-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 27, 2017 at 02:34:35PM +0800, Su Yue wrote:
> The head three patches is independent from later two.
> Include:
> 1) Let check_extent_refs() return error instead of 0 if something wrong
>    is found in original mode.
> 2) repair_root_items() should be called before any repair. Put it
>    before do_check_chunks_and_extents();
> 3) Error status should not be modified if repair_root_items() succeeded
>    in original repair.
> 
> The late two patches are about invalid type in extent_inline_ref.
> 
> Only original mode applied 001-003 patches can handle the case in the
> last patch. So I gather those 5 patches together.
> 
> 
> Su Yue (5):
>   btrfs-progs: check: return value of check_extent_refs()
>   btrfs-progs: check: call repair_root_items() before any repair
>   btrfs-progs: check: error or return value of repair_root_items()
>   btrfs-progs: check: check extent_inline_ref in lowmem
>   btrfs-progs: fsck-tests: 027/bad_extent_inline_ref_type

1-5 applied, with minor adjustments. Thanks.
