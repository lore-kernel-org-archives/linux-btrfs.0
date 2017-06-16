Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:23680 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751755AbdFPGaY (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Jun 2017 02:30:24 -0400
Subject: Re: [PATCH v3 0/9] btrfs: check name_len before read name
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20170606095708.494-1-suy.fnst@cn.fujitsu.com>
 <20170615155730.GC25451@twin.jikos.cz>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <cd0930f2-b17f-f766-bb5b-0e8b1dbf3458@cn.fujitsu.com>
Date: Fri, 16 Jun 2017 14:32:28 +0800
MIME-Version: 1.0
In-Reply-To: <20170615155730.GC25451@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/15/2017 11:57 PM, David Sterba wrote:
> On Tue, Jun 06, 2017 at 05:56:59PM +0800, Su Yue wrote:
>> When reading out name from inode_ref, dir_item, it's possible that
>> corrupted name_len leads to read beyond boundary.
>> Since there are already patches for btrfs-progs, this patchset is
>> for btrfs.
>>
>> Introduce 'btrfs_is_name_len_valid' to make check name_len with
>> item boundary.
>> If read name from dir_item, use 'verify_dir_item' to do more strict
>> check. Otherwise, use 'btrfs_is_name_len_valid'.
>>
>> It's unnessary to do check before every read/memcmp_extent_buffer name.
>> Checking name_len when read name for the first time in the call graph is
>> enough.
>>
>> Changlog:
>> v2:
>> 	1.Change 'btrfs_check_namelen' to 'btrfs_is_namelen_valid'.
>> 	2.Split patches according call graph.
>> v3:
>> 	1.Add cases about BTRFS_ROOT_REF_KEY and BTRFS_ROOT_BACKREF_KEY.
>> 	2.Add more comments about how/where extent_buffer is to be read
>> 	for the first time.
>> 	3.Change 'namelen' to 'name_len' in function and changelog.
> 
> I still see some fstests fail, eg. btrfs/048
> 
> trfs/048 30s ...       [18:05:48] [18:06:18] - output mismatch (see /root/test/mmtests/work/testdisk/sources/xfstests-git-installed/results//btrfs/048.out.bad)
>      --- tests/btrfs/048.out     2017-04-24 16:56:02.268104570 +0200
>      +++ /root/test/mmtests/work/testdisk/sources/xfstests-git-installed/results//btrfs/048.out.bad      2017-06-15 18:06:18.996635908 +0200
>      @@ -30,22 +30,13 @@
>       ERROR: failed to set compression for SCRATCH_MNT/testdir/file1: Invalid argument
>       ***
>       compression=lzo
>      -compression=lzo
>      -compression=zlib
>       ***
>      -compression=lzo
>      ...
> 
> in syslog with several lines
> 
> [ 2156.970285] BTRFS critical (device sdb6): invalid dir item name len: 17
> 
> and
> 
> [ 2157.220219] BTRFS error (device sdb6): error loading props for ino 259 (root 5): -5
> 
> similarly btrfs/059 fails. Have you seen such errors during your testing?
> 
> 
TBH, I just realized I messed up the test because of wrong git operations.
The problem is caused by that btrfs_is_name_len_vallid() does not handle 
data_len in XATTR_ITEM.
Sorry for my carelessness.


