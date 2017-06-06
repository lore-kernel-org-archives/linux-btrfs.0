Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53021 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751384AbdFFNYf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Jun 2017 09:24:35 -0400
Date: Tue, 6 Jun 2017 15:23:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 0/9] btrfs: check name_len before read name
Message-ID: <20170606132330.GC2918@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 06, 2017 at 05:56:59PM +0800, Su Yue wrote:
> When reading out name from inode_ref, dir_item, it's possible that
> corrupted name_len leads to read beyond boundary.
> Since there are already patches for btrfs-progs, this patchset is
> for btrfs.
> 
> Introduce 'btrfs_is_name_len_valid' to make check name_len with
> item boundary.
> If read name from dir_item, use 'verify_dir_item' to do more strict
> check. Otherwise, use 'btrfs_is_name_len_valid'.
> 
> It's unnessary to do check before every read/memcmp_extent_buffer name.
> Checking name_len when read name for the first time in the call graph is
> enough.
> 
> Changlog:
> v2:
> 	1.Change 'btrfs_check_namelen' to 'btrfs_is_namelen_valid'.
> 	2.Split patches according call graph.
> v3:
> 	1.Add cases about BTRFS_ROOT_REF_KEY and BTRFS_ROOT_BACKREF_KEY.
> 	2.Add more comments about how/where extent_buffer is to be read
> 	for the first time.
> 	3.Change 'namelen' to 'name_len' in function and changelog.

Thanks, overall looks good to me now. I've edited the changelogs, the
quoting of functions looks a bit strange to read, I hope you don't mind
me doing that.

I'll add the branch to for-next again, will add more reviewed-by should
they come. You don't need to resend the patchset, but if you find
something to fix, please let me know, we'll see if it's worth a separate
patch or an in-place fix.
