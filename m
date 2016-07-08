Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34113 "EHLO
	mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874AbcGHOnr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Jul 2016 10:43:47 -0400
Received: by mail-qk0-f195.google.com with SMTP id 82so10202333qko.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Jul 2016 07:43:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALLEBqFetJRAnwc0sYG-1seAGFBQu9-2nstH8hg-a1drdVdW_g@mail.gmail.com>
References: <CALLEBqG65hkAd+KyoNZudCKv58OuBm3L5VOjWcvMQ5GfGNCngA@mail.gmail.com>
 <CAJCQCtS=5Zx_toc3WuOpymyVUYFZMUo=wh+ZmTC=jh6bL3XYXg@mail.gmail.com>
 <CALLEBqF7HZ0VmMpFmoTik0_2FBXp7q5Z4EHxe_fMDY9ni2j44Q@mail.gmail.com>
 <CALLEBqFoy0MXgPJBHG=yQnXQwWJsBQJFBofNqwmJTjZFK9sV2g@mail.gmail.com>
 <CALLEBqGr9-jnba4XTV=JaVuNKPhNgEJuLZFmmLEkw-7HOB-Asg@mail.gmail.com>
 <CAPmG0jZP_0GJ_L0dh76hZPdcewtcy56E3cttgJrydC6cT7Mqwg@mail.gmail.com> <CALLEBqFetJRAnwc0sYG-1seAGFBQu9-2nstH8hg-a1drdVdW_g@mail.gmail.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Fri, 8 Jul 2016 16:43:46 +0200
Message-ID: <CAPmG0jZAFyVDhkQE5g6MzL8fQikD7p2xC21X6vbJa+=UkiSJmA@mail.gmail.com>
Subject: Re: Out of space error even though there's 100 GB unused?
To: Stanislaw Kaminski <stasheck.fora@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 8, 2016 at 9:22 AM, Stanislaw Kaminski
<stasheck.fora@gmail.com> wrote:
> Huh.
>
> I left defrag running overnight, and now I'm back to my >200 GiB free
> space. Also, I got no "out of space" messages in Transmission, and it
> successfully downloaded few GBs.
>
> But in dmesg I have 209 traces, see attached.
>
> Does that say anything to you?

I get some vague clue about the problem, but no-one seems to know
exactly the root cause(s).
The 4.6.2 code where the warning comes from is this:
...
/*
 * Called if we need to clear a data reservation for this inode
 * Normally in a error case.
 *
 * This one will *NOT* use accurate qgroup reserved space API, just for case
 * which we can't sleep and is sure it won't affect qgroup reserved space.
 * Like clear_bit_hook().
 */
void btrfs_free_reserved_data_space_noquota(struct inode *inode, u64 start,
                                            u64 len)
{
   struct btrfs_root *root = BTRFS_I(inode)->root;
   struct btrfs_space_info *data_sinfo;

   /* Make sure the range is aligned to sectorsize */
   len = round_up(start + len, root->sectorsize) -
       round_down(start, root->sectorsize);
   start = round_down(start, root->sectorsize);

   data_sinfo = root->fs_info->data_sinfo;
   spin_lock(&data_sinfo->lock);
   if (WARN_ON(data_sinfo->bytes_may_use < len))
           data_sinfo->bytes_may_use = 0;
   else
           data_sinfo->bytes_may_use -= len;
   trace_btrfs_space_reservation(root->fs_info, "space_info",
                               data_sinfo->flags, len, 0);
   spin_unlock(&data_sinfo->lock);
}
...

I think the system is still 'recovering' from getting stuck earlier.
What exactly that is, I don't know. You would probably need to enable
more debugging facilities in order to figure out from which file or
inode the problem comes from. I don't know if you can compile a 4.7
kernel for this Kirkwood SoC, but that would be one way forward. (BTW,
is it a 88F6281 or  a 88F6282 ?)

As far as I remember, Josef Basik has posted some patches that could
benefit this case, I am not sure if they made it in 4.7, but that is
what I think I would try.

Otherwise, it are workarounds:
- you could have a look at the cpuload during defrag and normal
operation and see how it relates to the rate of issuing this warning
- add mount option noatime
- as it looks like this this fs is (also) a torrent-client target, you
can put the torrents in a directoru ot subvol with noCoW flag set or
mount the whole fs with nodatacow
- again clean cache and then mount with space_cache=v2. Then new
mounts will use v2 then automatically. Only thing I can say it that
helped me getting out of kernel crash situation with 4.6.2. 4.7.0-rc5
did not crash on the same fs, so I got it working again (
de-allocations and cleanups, the fs is almost exclusively a
btrfs-receive target)
- connect the fs to a multi-core x86_64 system running same kernel
version for some time and see if you can reproduce the same type of
WARN_ONs
