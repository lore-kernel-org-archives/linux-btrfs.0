Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:33366 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751777AbdIAMiv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Sep 2017 08:38:51 -0400
Received: by mail-qk0-f193.google.com with SMTP id k126so85634qkb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Sep 2017 05:38:51 -0700 (PDT)
Date: Fri, 1 Sep 2017 08:38:49 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Naohiro Aota <naohiro.aota@wdc.com>
Cc: linux-btrfs@vger.kernel.org, fdmanana@suse.com, clm@fb.com,
        dsterba@suse.com, jbacik@fb.com, quwenruo.btrfs@gmx.com
Subject: Re: [PATCH 1/2] btrfs: clear ordered flag on cleaning up ordered
 extents
Message-ID: <20170901123848.x7m3rlgaow55bznv@destiny>
References: <150425632766.4737.133868215044509089.stgit@naota.dhcp.fujisawa.hgst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <150425632766.4737.133868215044509089.stgit@naota.dhcp.fujisawa.hgst.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 01, 2017 at 05:58:47PM +0900, Naohiro Aota wrote:
> commit 524272607e88 ("btrfs: Handle delalloc error correctly to avoid
> ordered extent hang") introduced btrfs_cleanup_ordered_extents() to cleanup
> submitted ordered extents. However, it does not clear the ordered bit
> (Private2) of coresponding pages. Thus, the following BUG occurs from
> free_pages_check_bad() (on btrfs/125 with nospace_cache).
> 
> BUG: Bad page state in process btrfs  pfn:3fa787
> page:ffffdf2acfe9e1c0 count:0 mapcount:0 mapping:          (null) index:0xd
> flags: 0x8000000000002008(uptodate|private_2)
> raw: 8000000000002008 0000000000000000 000000000000000d 00000000ffffffff
> raw: ffffdf2acf5c1b20 ffffb443802238b0 0000000000000000 0000000000000000
> page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
> bad because of flags: 0x2000(private_2)
> 
> This patch clear the flag as same as other places calling
> btrfs_dec_test_ordered_pending() for every page in the specified range.
> 

Reviewed-by: Josef Bacik <jbacik@fb.com>

Thanks,

Josef
