From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Rename a btrfs filesystem?
Date: Sat, 30 Apr 2011 12:33:55 +0700
Message-ID: <BANLkTim0OaNdYf2sb+UwzxCLTss6aW_bHg@mail.gmail.com>
References: <BANLkTikxuU4z-LXUcQptuaLZSZvUjmQSsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikxuU4z-LXUcQptuaLZSZvUjmQSsg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 30, 2011 at 9:24 AM, Evert Vorster <evorster@gmail.com> wrote:
> Hi there.
>
> Just a quick question: How do I rename an existing btrfs filesystem
> without destroying all the subvolumes on it?
>
> From mkfs.btrfs it says -L sets the initial filesystem label.
>
> With ext2, 3 and 4 the filesystem label can be changed with tune2fs.
> Does similar functionality exist in btrfs?

There's a patch for btrfsprogs which introduce a new command: btrfslabel
https://patchwork.kernel.org/patch/70701/

You might need to make some changes to merge it with current version,
but the userland-only patch works great for changing unmounted btrfs
filesystem. It works even without the kernel-side patch.

-- 
Fajar
