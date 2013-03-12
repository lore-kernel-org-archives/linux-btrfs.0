Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933135Ab3CLQka (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Mar 2013 12:40:30 -0400
Date: Tue, 12 Mar 2013 17:40:27 +0100
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/4 V2] btrfs-progs: rework get_fs_info to remove side
 effects
Message-ID: <20130312164027.GN7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1363043581-15812-1-git-send-email-sandeen@redhat.com>
 <1363043581-15812-5-git-send-email-sandeen@redhat.com>
 <513EAC64.7020706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <513EAC64.7020706@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 11, 2013 at 11:17:40PM -0500, Eric Sandeen wrote:
> * btrfs scrub start
> * btrfs scrub status

I did a quick test here:

$ mkfs.btrfs -d raid10 -m raid10 /dev/sda[5678]
$ mount /dev/sda5 /mnt
$ <fill with files> &
$ btrfs scrub start /dev/sda5
(ok)

$ btrfs scrub status /dev/sda5
(ok)

$ btrfs scrub status /mnt
(ok)

$ btrfs scrub cancel /mnt
^C^C^C^C^C^C^C^C<hang>
(exitted after a few minutes)

Name:   btrfs   State:  D (disk sleep)  Pid:    24214
[<ffffffffa008f625>] btrfs_scrub_cancel+0xc5/0x130 [btrfs]
[<ffffffffa006ab40>] btrfs_ioctl+0x13b0/0x1d90 [btrfs]
[<ffffffff81172ee6>] do_vfs_ioctl+0x96/0x560
[<ffffffff81173407>] sys_ioctl+0x57/0x90
[<ffffffff819698d9>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

(gdb) l *(btrfs_scrub_cancel+0xc5)
0x8f625 is in btrfs_scrub_cancel (fs/btrfs/scrub.c:2983).
2978            }
2979
2980            atomic_inc(&fs_info->scrub_cancel_req);
2981            while (atomic_read(&fs_info->scrubs_running)) {
2982                    mutex_unlock(&fs_info->scrub_lock);
2983                    wait_event(fs_info->scrub_pause_wait,
^^^^
2984                               atomic_read(&fs_info->scrubs_running) == 0);
2985                    mutex_lock(&fs_info->scrub_lock);
2986            }
2987            atomic_dec(&fs_info->scrub_cancel_req);

I don't know yet if this happens without this changes, will check next.

david
