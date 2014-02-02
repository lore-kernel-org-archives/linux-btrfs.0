Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:46633 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaBBB2J (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Feb 2014 20:28:09 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <alpine.DEB.2.02.1402011611400.5908@chino.kir.corp.google.com>
References: <52EAC9B6.7090603@fb.com>
	<alpine.DEB.2.02.1402011611400.5908@chino.kir.corp.google.com>
Date: Sun, 2 Feb 2014 01:28:07 +0000
Message-ID: <CAL3q7H5OW8GXUYB3rDMVf0Z7b-xPEbePWCg34wK8Y6HYXkn0zg@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs
From: Filipe David Manana <fdmanana@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Chris Mason <clm@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 2, 2014 at 12:15 AM, David Rientjes <rientjes@google.com> wrote:
> On Thu, 30 Jan 2014, Chris Mason wrote:
>
>>
>> Hi Linus
>>
>> Please pull my for-linus branch:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs.git for-linus
>>
>> There are two conflicts right now, one with the ACL code (pick your
>> version) and one with Kent's changes in the block layer pull.  That one
>> is pretty obvious too, just do both our cleanup and Kent's rework.
>>
>> This is a pretty big pull, and most of these changes have been floating
>> in btrfs-next for a long time.  Filipe's properties work is a cool
>> building block for inheriting attributes like compression down on a
>> per inode basis.
>>
>> Jeff Mahoney kicked in code to export filesystem info into sysfs.
>>
>> Otherwise, lots of performance improvements, cleanups and bug fixes.
>>
>> Looks like there are still a few other small pending incrementals, but I
>> wanted to get the bulk of this in first.
>>
>> Filipe David Borba Manana (29) commits (+1856/-301):
>>     Btrfs: fix deadlock when iterating inode refs and running delayed inodes (+12/-7)
>>     Btrfs: fix send file hole detection leading to data corruption (+15/-0)
>>     Btrfs: remove field tree_mod_seq_elem from btrfs_fs_info struct (+0/-1)
>>     Btrfs: make send's file extent item search more efficient (+17/-10)
>>     Btrfs: fix infinite path build loops in incremental send (+518/-21)
>>     Btrfs: reduce btree node locking duration on item update (+14/-10)
>>     Btrfs: return immediately if tree log mod is not necessary (+1/-1)
>>     Btrfs: fix pass of transid with wrong endianness in send.c (+3/-3)
>>     Btrfs: fix btrfs_search_slot_for_read backwards iteration (+3/-1)
>>     Btrfs: fix send to not send non-aligned clone operations (+2/-1)
>>     Btrfs: faster and more efficient extent map insertion (+41/-31)
>>     Btrfs: fix extent boundary check in bio_readpage_error (+1/-1)
>>     Btrfs: faster file extent item search in clone ioctl (+14/-9)
>>     Btrfs: unlock inodes in correct order in clone ioctl (+11/-3)
>>     Btrfs: faster file extent item replace operations (+114/-46)
>>     Btrfs: avoid unnecessary ordered extent cache resets (+2/-1)
>>     Btrfs: fix very slow inode eviction and fs unmount (+84/-14)
>>     Btrfs: fix snprintf usage by send's gen_unique_name (+1/-1)
>>     Btrfs: fix ordered extent check in btrfs_punch_hole (+1/-1)
>>     Btrfs: fix btrfs boot when compiled as built-in (+73/-9)
>
> This one, 14a958e678cd ("Btrfs: fix btrfs boot when compiled as
> built-in"), breaks the build if CONFIG_LIBCRC32C=m:
>
> fs/built-in.o: In function `btrfs_check_super_csum':
> disk-io.c:(.text+0x1a1c8b): undefined reference to `crc32c'
> fs/built-in.o: In function `write_dev_supers.isra.120':
> disk-io.c:(.text+0x1a2054): undefined reference to `crc32c'
> fs/built-in.o: In function `csum_tree_block.isra.122':
> disk-io.c:(.text+0x1a22c4): undefined reference to `crc32c'
> fs/built-in.o: In function `btrfs_csum_data':
> (.text+0x1a2a46): undefined reference to `crc32c'
> fs/built-in.o: In function `send_cmd':
> send.c:(.text+0x20fe4c): undefined reference to `crc32c'

One of the kbuild test robots reported this a few days ago too.
The following patch, sent shortly after the robot's warning, fixes it:

https://patchwork.kernel.org/patch/3554671/

thanks



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
