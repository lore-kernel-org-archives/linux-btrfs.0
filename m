Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37512 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753149AbeFGLQm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 7 Jun 2018 07:16:42 -0400
Subject: Re: [PATCH v3 0/3] btrfs-progs: check: verify symlinks with
 append/immutable flags
To: Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <20180607065542.17273-1-suy.fnst@cn.fujitsu.com>
 <37bfcc00-0745-03e5-28b3-51d94bb658cd@suse.com>
 <4b24c79c-5d20-21ba-3237-955b256e9105@cn.fujitsu.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <5fb1804a-b278-e48f-0884-a5f7d23dd551@suse.com>
Date: Thu, 7 Jun 2018 14:16:39 +0300
MIME-Version: 1.0
In-Reply-To: <4b24c79c-5d20-21ba-3237-955b256e9105@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  7.06.2018 12:10, Su Yue wrote:
> 
> 
> On 06/07/2018 02:54 PM, Nikolay Borisov wrote:
>>
>>
>> On  7.06.2018 09:55, Su Yue wrote:
>>> This patchset can be fetch from my github:
>>> https://github.com/Damenly/btrfs-progs/commits/odd_inode_flags
>>> It's based on kdave/devel whose HEAD is:
>>> commit 1c846faaf87fbb01e080c94098c02b1695ed86dd
>>> Author: Nikolay Borisov <nborisov@suse.com>
>>> Date:   Mon May 28 09:36:50 2018 +0300
>>>
>>>     btrfs-progs: Remove fs_info argument from write_ctree_super
>>>     
>>> symlinks should never have append/immutable attributes.
>>> This patchset enables btrfs check to verify such corruption.
>>>
>>> PATCH[1] is for original mode.
>>> PATCH[2] is for original mode.
>>>
>>> PATCH[3] adds a test image.
>>> For further use, the directory is called bad-inode-flags.
>>>
>>> #issue 133
>>
>>
>> So you areadding code to detect the problem but not to fix it. Is there
>> some technical reason why you didn't implement clearing those flags or
>> just didn't do it for this series? IMHO it will be good if the check +
> 
> TBH I just didn't plan to do it while writing the patches.
> If the functionality of repair is necessary, I'm willing to
> do it.

That's fine, however in case this code detects such a symlink what's the
user supposed to do - they can just delete the symlink because it's
immutable/append-only. SO they will know they have such symlinks but
won't be able to repair them.

> 
> However, it seems I have to complete work about repair mismatched file
> type first. So we can verify whether a bad inode is a symlink with
> append/immutable attributes or a normal file set with BTRFS_FT_SYMLINK.
> 
> I'm fine that v2 patchset is to be replaced then support repair late
> or to be reverted.
> 
> Thanks,
> Su
> 
>> repair code are part of the same series. Then you can also extend the
>> test case to cover the 2 functionalities?
>>
>>>
>>> ---
>>> Changelog:
>>> v3:
>>>    Use S_ISLNK instead of BTRFS_FT_SYMLINK. Thanks Misono.
>>>    Change the test image created by hand.
>>> v2:
>>>    Use "rec->errors |=" instead of "rec->errors =" in patch[1].
>>>    Define new error bit of invalid inode flags in lowmem mode.
>>>    Adjust print message in patch[2]. Thanks, Qu and Nikolay.
>>>    Rename test directory from odd-inode-flags to bad-inode-flags.
>>>
>>> Su Yue (3):
>>>    btrfs-progs: check: check symlinks with append/immutable flags
>>>    btrfs-progs: check: lowmem: check symlinks with append/immutable
>>> flags
>>>    btrfs-progs: fsck-tests: add test case to check symlinks with bad
>>>      flags
>>>
>>>   check/main.c                                     |   7 +++++++
>>>   check/mode-lowmem.c                              |  10 ++++++++++
>>>   check/mode-lowmem.h                              |   1 +
>>>   check/mode-original.h                            |   1 +
>>>   .../034-bad-inode-flags/default_case.img         | Bin 0 -> 4096 bytes
>>>   tests/fsck-tests/034-bad-inode-flags/test.sh     |  15 +++++++++++++++
>>>   6 files changed, 34 insertions(+)
>>>   create mode 100644
>>> tests/fsck-tests/034-bad-inode-flags/default_case.img
>>>   create mode 100755 tests/fsck-tests/034-bad-inode-flags/test.sh
>>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> 
> 
> 
