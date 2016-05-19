Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:36521 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754484AbcESQyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 May 2016 12:54:51 -0400
Received: by mail-lf0-f68.google.com with SMTP id y84so6292415lfc.3
        for <linux-btrfs@vger.kernel.org>; Thu, 19 May 2016 09:54:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ba18afa9-a72e-01d0-4d86-75fef5b0ffaa@cn.fujitsu.com>
References: <1463456878-17550-1-git-send-email-quwenruo@cn.fujitsu.com>
 <d2ae6dd2-13e0-eb5e-f1a9-9260dc8188c7@cn.fujitsu.com> <CADzmB21LFX+qMsVSiCOk9mPg_+42po01Vsw1iPFxuCT2UA8yTA@mail.gmail.com>
 <ba18afa9-a72e-01d0-4d86-75fef5b0ffaa@cn.fujitsu.com>
From: Ivan P <chrnosphered@gmail.com>
Date: Thu, 19 May 2016 18:54:28 +0200
Message-ID: <CADzmB209Oxxg-HpzLKBRgx0_-hQ8-WCNK4tU9+sANvvqQV5JqQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] Add support to clear v1 free space cache for btrfs check
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, dsterba@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Not sure why I was so fixated on installing it - thanks for reminding.

I was able to run it, but it fails:
===========================
# ./btrfsck --repair --clear-space-cache -p /dev/sda
enabling repair mode
Clearing all free space cache
btrfs unable to find ref byte nr 812846673920 parent 0 root 1  owner
1050 offset 0
ERROR: failed to remove backref for disk bytenr 812846673920
ERROR: failed to clear free space cache
transaction.h:41: btrfs_start_transaction: Assertion `root->commit_root` failed.
btrfs check[0x4437ee]
btrfs check(close_ctree_fs_info+0x213)[0x445ab3]
btrfs check(cmd_check+0x638)[0x42b718]
btrfs check(main+0x7b)[0x40fbdb]
/usr/lib/libc.so.6(__libc_start_main+0xf1)[0x7fe4ebe1a741]
btrfs check(_start+0x29)[0x40fcd9]
===========================

I also tried running it WITHOUT --repair first, as well as ONLY with
--repair, followed by --clearcache and same thing happened.
I must add that I feel cheated by the "-p" option, it's more of a
"print heartbeat" than "print progress" IMHO :p

@David Sterba: you're welcome.

Regards,
Ivan.

On Wed, May 18, 2016 at 3:00 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Not familiar about the problem, but you don't really need to install the
> patch.
>
> You can just execute '<your btrfs-progs source dir>/btrfsck' directly to
> call the new fsck.
>
> And there is still some time before the patch is merged, there is really no
> need to install.
>
> Thanks,
> Qu
>
>
> Ivan P wrote on 2016/05/17 20:12 +0200:
>>
>> Thank you, however I can't seem to be able to compile that snapshot, I'm
>> getting
>>
>> ===========================
>> /usr/bin/install -c -m644 -d 64-btrfs-dm.rules
>> /home/myuser/aur/btrfs-progs-git/pkg/btrfs-progs-git/usr/lib/udev/rules.d
>> /usr/bin/install: cannot create directory ‘64-btrfs-dm.rules’: File exists
>> Makefile:400: recipe for target 'install' failed
>> make: *** [install] Error 1
>> ==> ERROR: A failure occurred in package()
>> ===========================
>>
>> Just to make sure I wasn't screwing up somewhere, I tried the
>> btrfs-progs-git AUR package and I'm getting the same thing.
>> It's not only me, however: according to [1] it could be that this
>> commit has introduced it: [2]
>>
>> Regards,
>> Ivan.
>>
>> [1] https://aur.archlinux.org/packages/btrfs-progs-git/
>> [2]
>> http://repo.or.cz/btrfs-progs-unstable/devel.git?a=commit;h=ebe5b1cc7885027521db3c1d16d84bd54cc1321b
>>
>> On Tue, May 17, 2016 at 5:56 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>> wrote:
>>>
>>> Also to Ivan P, the initial reporter of the problem.
>>>
>>> Now "btrfsck --clear-cache" should help you to prevent kernel warning on
>>> free space cache problem.
>>>
>>> Thanks,
>>> Qu
>>>
>>> Qu Wenruo wrote on 2016/05/17 11:47 +0800:
>>>>
>>>>
>>>> The patchset can be also fetched from github, just in case mail list
>>>> blocks the last patch, which contains binary file.
>>>> https://github.com/adam900710/btrfs-progs.git fsck_clear_cache
>>>>
>>>> Just as describe in the first patch, btrfs kernel "clear_cache" mount
>>>> option can't rebuild all free space cache, due to the design of free
>>>> space cache.
>>>> (Although I pretty like the idea to delay the load of free space cache,
>>>> as it hugely reduce the mount time of large fs)
>>>>
>>>> So this makes users to report error in mail list, complaining
>>>> "clear_cache" doesn't wipe the annoying kernel warning on corrupted free
>>>> space cache.
>>>>
>>>> Since kernel can't handle it, and user consider it more like an error,
>>>> we'd better handle it like an error, to fix it in btrfs check.
>>>>
>>>> So this patchset adds the ability to clear free space cache, and add
>>>> test case for it.
>>>>
>>>> The clear procedure is different from kernel, it will remove all free
>>>> space cache inodes and its contents(with backrefs), and set
>>>> cache_generation of super block to -1.
>>>> So there will be no free space cache at all and kernel will be happy
>>>> with that.
>>>>
>>>> This patch also enhances btrfs_previous_item() to use min_objectid to
>>>> return as early as possible.
>>>>
>>>> Lu Fengqi (1):
>>>>   btrfs-progs: tests: add 020-bad-free-space-cache
>>>>
>>>> Qu Wenruo (3):
>>>>   btrfs-progs: corrupt-block: Add ability to corrupt free space cache
>>>>     file
>>>>   btrfs-progs: ctree: return earlier for btrfs_previous_item
>>>>   btrfs-progs: fsck: Add support to clear free space cache
>>>>
>>>>  Documentation/btrfs-check.asciidoc                 |   8 ++
>>>>  btrfs-corrupt-block.c                              | 124
>>>> ++++++++++++++++++++-
>>>>  cmds-check.c                                       |  58 +++++++++-
>>>>  ctree.c                                            |   2 +
>>>>  free-space-cache.c                                 | 124
>>>> +++++++++++++++++++++
>>>>  free-space-cache.h                                 |   4 +
>>>>  .../020-bad-free-space-cache/default_case.raw.xz   | Bin 0 -> 164068
>>>> bytes
>>>>  tests/fsck-tests/020-bad-free-space-cache/test.sh  |  16 +++
>>>>  8 files changed, 334 insertions(+), 2 deletions(-)
>>>>  create mode 100644
>>>> tests/fsck-tests/020-bad-free-space-cache/default_case.raw.xz
>>>>  create mode 100755 tests/fsck-tests/020-bad-free-space-cache/test.sh
>>>>
>>>
>>>
>>
>>
>
>
