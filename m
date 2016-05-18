Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:36896 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752299AbcERBA6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 May 2016 21:00:58 -0400
Subject: Re: [PATCH 0/4] Add support to clear v1 free space cache for btrfs
 check
To: Ivan P <chrnosphered@gmail.com>
References: <1463456878-17550-1-git-send-email-quwenruo@cn.fujitsu.com>
 <d2ae6dd2-13e0-eb5e-f1a9-9260dc8188c7@cn.fujitsu.com>
 <CADzmB21LFX+qMsVSiCOk9mPg_+42po01Vsw1iPFxuCT2UA8yTA@mail.gmail.com>
CC: btrfs <linux-btrfs@vger.kernel.org>, <dsterba@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <ba18afa9-a72e-01d0-4d86-75fef5b0ffaa@cn.fujitsu.com>
Date: Wed, 18 May 2016 09:00:49 +0800
MIME-Version: 1.0
In-Reply-To: <CADzmB21LFX+qMsVSiCOk9mPg_+42po01Vsw1iPFxuCT2UA8yTA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not familiar about the problem, but you don't really need to install the 
patch.

You can just execute '<your btrfs-progs source dir>/btrfsck' directly to 
call the new fsck.

And there is still some time before the patch is merged, there is really 
no need to install.

Thanks,
Qu

Ivan P wrote on 2016/05/17 20:12 +0200:
> Thank you, however I can't seem to be able to compile that snapshot, I'm getting
>
> ===========================
> /usr/bin/install -c -m644 -d 64-btrfs-dm.rules
> /home/myuser/aur/btrfs-progs-git/pkg/btrfs-progs-git/usr/lib/udev/rules.d
> /usr/bin/install: cannot create directory ‘64-btrfs-dm.rules’: File exists
> Makefile:400: recipe for target 'install' failed
> make: *** [install] Error 1
> ==> ERROR: A failure occurred in package()
> ===========================
>
> Just to make sure I wasn't screwing up somewhere, I tried the
> btrfs-progs-git AUR package and I'm getting the same thing.
> It's not only me, however: according to [1] it could be that this
> commit has introduced it: [2]
>
> Regards,
> Ivan.
>
> [1] https://aur.archlinux.org/packages/btrfs-progs-git/
> [2] http://repo.or.cz/btrfs-progs-unstable/devel.git?a=commit;h=ebe5b1cc7885027521db3c1d16d84bd54cc1321b
>
> On Tue, May 17, 2016 at 5:56 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> Also to Ivan P, the initial reporter of the problem.
>>
>> Now "btrfsck --clear-cache" should help you to prevent kernel warning on
>> free space cache problem.
>>
>> Thanks,
>> Qu
>>
>> Qu Wenruo wrote on 2016/05/17 11:47 +0800:
>>>
>>> The patchset can be also fetched from github, just in case mail list
>>> blocks the last patch, which contains binary file.
>>> https://github.com/adam900710/btrfs-progs.git fsck_clear_cache
>>>
>>> Just as describe in the first patch, btrfs kernel "clear_cache" mount
>>> option can't rebuild all free space cache, due to the design of free
>>> space cache.
>>> (Although I pretty like the idea to delay the load of free space cache,
>>> as it hugely reduce the mount time of large fs)
>>>
>>> So this makes users to report error in mail list, complaining
>>> "clear_cache" doesn't wipe the annoying kernel warning on corrupted free
>>> space cache.
>>>
>>> Since kernel can't handle it, and user consider it more like an error,
>>> we'd better handle it like an error, to fix it in btrfs check.
>>>
>>> So this patchset adds the ability to clear free space cache, and add
>>> test case for it.
>>>
>>> The clear procedure is different from kernel, it will remove all free
>>> space cache inodes and its contents(with backrefs), and set
>>> cache_generation of super block to -1.
>>> So there will be no free space cache at all and kernel will be happy
>>> with that.
>>>
>>> This patch also enhances btrfs_previous_item() to use min_objectid to
>>> return as early as possible.
>>>
>>> Lu Fengqi (1):
>>>   btrfs-progs: tests: add 020-bad-free-space-cache
>>>
>>> Qu Wenruo (3):
>>>   btrfs-progs: corrupt-block: Add ability to corrupt free space cache
>>>     file
>>>   btrfs-progs: ctree: return earlier for btrfs_previous_item
>>>   btrfs-progs: fsck: Add support to clear free space cache
>>>
>>>  Documentation/btrfs-check.asciidoc                 |   8 ++
>>>  btrfs-corrupt-block.c                              | 124
>>> ++++++++++++++++++++-
>>>  cmds-check.c                                       |  58 +++++++++-
>>>  ctree.c                                            |   2 +
>>>  free-space-cache.c                                 | 124
>>> +++++++++++++++++++++
>>>  free-space-cache.h                                 |   4 +
>>>  .../020-bad-free-space-cache/default_case.raw.xz   | Bin 0 -> 164068
>>> bytes
>>>  tests/fsck-tests/020-bad-free-space-cache/test.sh  |  16 +++
>>>  8 files changed, 334 insertions(+), 2 deletions(-)
>>>  create mode 100644
>>> tests/fsck-tests/020-bad-free-space-cache/default_case.raw.xz
>>>  create mode 100755 tests/fsck-tests/020-bad-free-space-cache/test.sh
>>>
>>
>>
>
>


