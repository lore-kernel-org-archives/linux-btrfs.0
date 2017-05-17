Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58099 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752849AbdEQIXS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 17 May 2017 04:23:18 -0400
Subject: Re: [PATCH 0/5] btrfs-progs: check: simple errors repair in lowmem
From: Su Yue <suy.fnst@cn.fujitsu.com>
To: <linux-btrfs@vger.kernel.org>
References: <20170411032631.24932-1-suy.fnst@cn.fujitsu.com>
CC: David Sterba <dsterba@suse.cz>
Message-ID: <ef8b662b-ea60-4ea4-cd86-083b532b926c@cn.fujitsu.com>
Date: Wed, 17 May 2017 16:25:03 +0800
MIME-Version: 1.0
In-Reply-To: <20170411032631.24932-1-suy.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi
    This patchset was sent a month ago.
    Since it's a start of lowmem repair patches, I hope to get some
    opinions about it.

Thanks
Su Yue

On 04/11/2017 11:26 AM, Su Yue wrote:
> The series include following contents:
> 
> 1) Repair wrong nbytes of file inode item.
>     After traversal of extents in one file, we should get the actual nbytes
>     of the file. If nbytes in the file inode differs from the actual value,
>     set the value to actual one.
>     
>     The wrong nbytes of file inode case corresponds to fsck-test/016.
>     
> 2) Repair wrong iszie of directory inode item.
>     After traversal of dir_index and dir_item in one dir, we should get
>     the actual isize of the dirctory. If size in the inode item differs
>     from the actual value, set the value to actual one.
> 
>     New test case 'fsck-test/026' is added for the case wrong isize of
>     directory inode.
>     
> 3) Allow fsck check test to repair in lowmem mode for certain test cases
>     if TEST_ENABLE_OVERRIDE=true.
> 
> Qu Wenruo (1):
>    btrfs-progs: fsck-check: Allow fsck check test to repair in lowmem
>      mode for certain test cases
> 
> Su Yue (4):
>    btrfs-progs: check: inode nbytes fix in lowmem
>    btrfs-progs: check: dir isize fix in lowmem
>    btrfs-progs: check: enable lowmem repair
>    btrfs-progs: fsck-check: test cases for nbytes and dir isize
> 
>   cmds-check.c                                       | 149 +++++++++++++++++++--
>   tests/common.local                                 |  14 +-
>   .../016-wrong-inode-nbytes/.lowmem_repairable      |   0
>   .../026-wrong-dir-inode-isize/.lowmem_repairable   |   0
>   .../026-wrong-dir-inode-isize/default_case.img     | Bin 0 -> 4096 bytes
>   5 files changed, 153 insertions(+), 10 deletions(-)
>   create mode 100644 tests/fsck-tests/016-wrong-inode-nbytes/.lowmem_repairable
>   create mode 100644 tests/fsck-tests/026-wrong-dir-inode-isize/.lowmem_repairable
>   create mode 100644 tests/fsck-tests/026-wrong-dir-inode-isize/default_case.img
> 


