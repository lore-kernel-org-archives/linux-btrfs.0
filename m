Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:36666 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256AbcAaBJj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Jan 2016 20:09:39 -0500
Received: by mail-io0-f179.google.com with SMTP id g73so125573482ioe.3
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Jan 2016 17:09:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAKbQEqE0w5fewMw9YwooFXaEVT2ecfGf6ZCVvUmQg8SjGx2Zsw@mail.gmail.com>
References: <CAKbQEqE0w5fewMw9YwooFXaEVT2ecfGf6ZCVvUmQg8SjGx2Zsw@mail.gmail.com>
Date: Sat, 30 Jan 2016 18:09:38 -0700
Message-ID: <CAJCQCtS8TftFSzepEPGb8R+ZD=E_VETCZcd6HGmvkKGe_i9o7w@mail.gmail.com>
Subject: Re: "WARNING: device 0 not present" during scrub?
From: Chris Murphy <lists@colorremedies.com>
To: Christian Pernegger <pernegger@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 30, 2016 at 4:59 AM, Christian Pernegger
<pernegger@gmail.com> wrote:

> parent transid verify failed on 4693971959808 wanted 14495 found 14497
> parent transid verify failed on 4693971959808 wanted 14495 found 14497
> parent transid verify failed on 4693971959808 wanted 14495 found 14497
> parent transid verify failed on 4693971959808 wanted 14495 found 14497

Well it's not that far off so mounting with -o recovery should work.


> Ignoring transid failure
> print-tree.c:1074: btrfs_print_tree: Assertion failed.
> btrfs-debug-tree[0x410489]
> btrfs-debug-tree[0x411dbf]
> btrfs-debug-tree[0x402adb]
> /lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xf5)[0x7f925b1ccb45]
> btrfs-debug-tree[0x402d85]

It could be a bug, and if so there's a good chance it's fixed in newer
versions of btrfs-progs.



>
> Ouch.
>
> This is on a 1-month-old Debian stable (jessie) install and yes, I
> know that means the kernel and btrfs-progs are ancient but I'd still
> very much appreciate some help. It's a backup box, so the data isn't
> critical, but of course I need it stable in the long run.

Sorry, you need it to be stable but you're using an EOL unsupported
kernel? That just doesn't square.

It's either a hardware problem (there are many softreset message, and
possibly more than one ata instance than you have attached devices
for, and no Btrfs errors), or it's a software bug. Either way you
kinda need to try something newer to see if the problem has been since
been fixed, because it's in the realm of 10,000 changes (probably
more) since that kernel version you're using. There might be 4 people
on the list who'd maybe recognize this, and say, yes in fact that was
fixed in a newer kernel. So really no matter what you just have to
upgrade.


> Is it
> possible to fix this and prevent it from happening again? (How) can I
> verify if the data is still good?

The user space program crashed either due to a bug or it ran out of
memory. Maybe increase swap size, sometimes that helps btrfs check and
btrfs-debug-tree go farther without problems.

Try mounting with -o recovery. If that doesn't work try -o
recovery,ro, and if that doesn't work then try btrfs check (without
repair), using kernel and progs no older than 4.1.15. It's middle aged
in Btrfs terms, but at least that's a longterm currently maintained
kernel.


  If the verdict is that I have to
> re-roll the box I wouldn't go with btrfs again at this time, but still
> be willing to help with debugging first, if anyone is interested.

I can almost guarantee that if -o recovery does not work, no one will
want to suggest anything more aggressive if you also aren't willing to
upgrade kernel and tools to something much newer. Really, if you need
Btrfs to be stable, you need to use a distro that makes it easy for
you to get the latest bug fixes, not just features.

-- 
Chris Murphy
