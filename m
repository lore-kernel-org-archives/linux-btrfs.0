Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f47.google.com ([209.85.214.47]:45758 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754556Ab3HGDQg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Aug 2013 23:16:36 -0400
Received: by mail-bk0-f47.google.com with SMTP id mx12so70670bkb.6
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Aug 2013 20:16:34 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <5201B942.7050605@redhat.com>
References: <1375813640-14063-1-git-send-email-fdmanana@gmail.com>
	<5201B942.7050605@redhat.com>
Date: Wed, 7 Aug 2013 04:16:34 +0100
Message-ID: <CAL3q7H4g4FshkjXjZTXAXLTz6UCsHOPvu7HGom5s8FKze1ipWA@mail.gmail.com>
Subject: Re: [PATCH RFC] Btrfs: add support for persistent mount options
From: Filipe David Manana <fdmanana@gmail.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 7, 2013 at 4:04 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 8/6/13 1:27 PM, Filipe David Borba Manana wrote:
>> This change allows for most mount options to be persisted in
>> the filesystem, and be applied when the filesystem is mounted.
>> If the same options are specified at mount time, the persisted
>> values for those options are ignored.
>
> I thought the plan was to make commandline mount options
> override persistent ones, but that doesn't seem to be the case,
> at least in this example:

Yes, that was the idea. However I didn't try all possible combinations
of mount and persistent parameters.

>
> # ./btrfstune -o compress,discard,ssd /dev/sdb1
> New persistent options:      compress,discard,ssd
> # mount -o nossd /dev/sdb1 /mnt/test
> # dmesg | tail
> [  995.657233] btrfs: use ssd allocation scheme
> [  995.661501] btrfs: disk space caching is enabled

Yes. Misses some checks like the ones I added for the space_cache /
no_space_cache combinations:

+ if (token == Opt_no_space_cache &&
+    parsed[Opt_space_cache])
+ continue;
+ if (token == Opt_space_cache &&
+    parsed[Opt_no_space_cache])
+ continue;

>
> and /proc/mounts is similarly confused, showing both options:
>
> # grep sdb1 /proc/mounts
> /dev/sdb1 /mnt/test btrfs rw,seclabel,relatime,compress=zlib,nossd,ssd,discard,space_cache 0 0
>
> (This is the trail of woe I was talking about from ext4-land) ;)
>
>> The only options not supported are: subvol, subvolid, subvolrootid,
>> device and thread_pool. This limitation is due to how this feature
>> is implemented: basically there's an optional value (of type
>> struct btrfs_dir_item) in the tree of tree roots used to store the
>> list of options in the same format as they are passed to btrfs_mount().
>> This means any mount option that takes effect before the tree of tree
>> roots is setup is not supported.
>
> Just FWIW, vfs-level mount options are also not supported; i.e. "noatime"
> or "ro" won't work either, because the code is already past the VFS
> option parsing:
>
> # ./btrfstune -o compress,discard,ro /dev/sdb1
> Current persistent options:  compress,discard
> New persistent options:      compress,discard,ro
> # mount /dev/sdb1 /mnt/test
> mount: wrong fs type, bad option, bad superblock on /dev/sdb1, ...
> # dmesg | tail
> [  817.681417] btrfs: unrecognized mount option 'ro'
> [  817.694689] btrfs: open_ctree failed

Yes, that would be a next step to work on after getting community
feedback about the approach (from a user point of view and the
technical details / implementation).

Thanks for trying it and for your feedback Eric.

>
>> To set these options, the user space tool btrfstune was modified
>> to persist the list of options into an unmounted filesystem's
>> tree of tree roots.
>
> If this goes forward, you'd want an easy way to display
> them, not just set them, I suppose.
>
> Thanks,
> -Eric
>
>> NOTE: Like the corresponding btrfs-progs patch, this is a WIP with
>> the goal o gathering feedback.
>>
>> Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
