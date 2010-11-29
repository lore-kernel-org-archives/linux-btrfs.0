From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Default to read-only on snapshot creation and have a flag if snapshot
 should be writable (was: [PATCH 0/5] btrfs: Readonly snapshots)
Date: Mon, 29 Nov 2010 12:02:28 -0800
Message-ID: <AANLkTikbmUQA7JtkjV4177jmj9WDVe1V3NvbX3ts6TNd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org, Sage Weil <sage@newdream.net>
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 29, 2010 at 12:02 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> (Cc: Sage Weil <sage@newdream.net> for changes in async snapshots)
>
> This patchset adds readonly-snapshots support. You can create a
> readonly snapshot, and you can also set a snapshot readonly/writable
> on the fly.
>
> A few readonly checks are added in setattr, permission, remove_xattr
> and set_xattr callbacks, as well as in some ioctls.
>

Great work!

I have a suggestion on defaults when snapshots are created.  I think
they should default to being read-only and if they are meant to be
read-write a flag can be set at creation time (and changable at a
later time as well of course).

This way user/admin preconceptions of a snapshot being read-only can
be enforced by default, and the exception when you want a read-write
snapshot can be available with a switch at the cli level (and probably
a flag at the ioctl level).

It gives one more natural distinction between a snapshot and a
subvolume at the user conceptual level.

What do you think?
