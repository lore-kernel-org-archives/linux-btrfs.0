Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53133 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750727AbdFOP6g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Jun 2017 11:58:36 -0400
Date: Thu, 15 Jun 2017 17:57:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 0/9] btrfs: check name_len before read name
Message-ID: <20170615155730.GC25451@twin.jikos.cz>
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

I still see some fstests fail, eg. btrfs/048

trfs/048 30s ...       [18:05:48] [18:06:18] - output mismatch (see /root/test/mmtests/work/testdisk/sources/xfstests-git-installed/results//btrfs/048.out.bad)
    --- tests/btrfs/048.out     2017-04-24 16:56:02.268104570 +0200
    +++ /root/test/mmtests/work/testdisk/sources/xfstests-git-installed/results//btrfs/048.out.bad      2017-06-15 18:06:18.996635908 +0200
    @@ -30,22 +30,13 @@
     ERROR: failed to set compression for SCRATCH_MNT/testdir/file1: Invalid argument
     ***
     compression=lzo
    -compression=lzo
    -compression=zlib
     ***
    -compression=lzo
    ...

in syslog with several lines

[ 2156.970285] BTRFS critical (device sdb6): invalid dir item name len: 17

and

[ 2157.220219] BTRFS error (device sdb6): error loading props for ino 259 (root 5): -5

similarly btrfs/059 fails. Have you seen such errors during your testing?
