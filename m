From: cwillu <cwillu@cwillu.com>
Subject: Re: Boot speed/mount time regression with 3.4.0-rc2
Date: Mon, 9 Apr 2012 10:08:45 -0600
Message-ID: <CAE5mzvhjwDmMbaAUMQRbkTCjsi2jWYnrechCwoNJef7tGqa=9w@mail.gmail.com>
References: <1333986823.2928.6.camel@ayu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Calvin Walton <calvin.walton@kepstin.ca>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1333986823.2928.6.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Apr 9, 2012 at 9:53 AM, Calvin Walton <calvin.walton@kepstin.ca> wrote:
> Hi,
>
> I have a system that's using a dracut-generated initramfs to mount a
> btrfs root. After upgrading to kernel 3.4.0-rc2 to test it out, I've
> noticed that the process of mounting the root filesystem takes much
> longer with 3.4.0-rc2 than it did with 3.3.1 - nearly 30 seconds slower!
>
> Does anyone have any ideas? I'm going to try bisecting the issue to see
> if I can narrow down the cause. I've included excerpts from dmesg of the
> bad and good kernels here, and attached the complete dmesg from the bad
> kernel, in case it has anything interesting that I've trimmed out here.

That sounds suspiciously like a symlink from btrfsck is to fsck.btrfs
was added at about the same time as the update (old initrd maybe?).
