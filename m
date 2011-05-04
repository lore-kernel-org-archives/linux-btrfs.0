From: Josef Bacik <josef@redhat.com>
Subject: Re: kernel BUG at fs/btrfs/inode.c:149!
Date: Wed, 04 May 2011 10:46:44 -0400
Message-ID: <4DC166D4.4000801@redhat.com>
References: <201105041626.36039.whirm@gmx.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: whirm@gmx.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105041626.36039.whirm@gmx.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/04/2011 10:26 AM, whirm@gmx.com wrote:
> Hi all,
>
> Here's a traceback from a failed attempt to mount a btrfs in lvm in luks
> filesystem.
>
> Note that if I mount it readonly it mounts successfully (haven't tried to
> recover any data as I have recent backups).
>
> Yesterday I defragmented both / and /home with:
>
> find /home -xdev -type f -print0 | xargs -0 sudo ./btrfs filesystem defragment
> -c
>
> with btrfs-tools v0.19-35-g1b444cd and rebooted a couple of times. And today I
> got this traceback while trying to mount home at boot time (/ is working ok)
>
> btrfsck fails with the following error:
>
> couldn't open because of unsupported option features (8).
> btrfsck: disk-io.c:682: open_ctree_fd: Assertion `!(1)' failed.
>
> I'm using a 2.6.39-rc5+ kernel from Linus' tree.
>
> If someone needs any extra info, just ask for it, Ill keep the corrupted
> filesystem for a few days before destroying it.
>
> Thanks.
>

I just posted a patch for this, please try

[PATCH] Btrfs: fix how we do space reservation for truncate

thanks,

Josef
