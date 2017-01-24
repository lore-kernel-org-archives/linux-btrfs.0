Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:33797 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750713AbdAXShp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jan 2017 13:37:45 -0500
Received: by mail-yw0-f194.google.com with SMTP id v73so21526235ywg.1
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Jan 2017 10:37:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170124174907.GA27340@vader>
References: <CAJCQCtT73Zh2F13tg3v4UZC3+rdTMhgC==Ag3LZQ-RZMTpisOg@mail.gmail.com>
 <CAJCQCtSZyfHdmsaVdEM7iQiKfK-s4Qqs4ORZrE1MCpWCgeCWbw@mail.gmail.com>
 <CAJCQCtQz5fhYymEgFuxuiactZpWeUSEeCCXFCAEmLTTA6AOZLQ@mail.gmail.com>
 <20170123213109.GA11778@vader.DHCP.thefacebook.com> <CAJCQCtSVXRXvGmnmfFt5yn_L33a8eCCuuFANxTOyWLrJeqrK9g@mail.gmail.com>
 <CAJCQCtRip_D7BPhCJDVP53LRoQoEcVrvCf7eyGK9sa8qv23BNQ@mail.gmail.com>
 <20170123220448.GB11778@vader.DHCP.thefacebook.com> <CAJCQCtQNgvu72GUBpvJtnAH-Sj-fd566HwDpeuGjaPmdtrUO3g@mail.gmail.com>
 <20170124000524.GC11778@vader.DHCP.thefacebook.com> <CAJCQCtSHx8cEanC7e71akLiRKzi+Rt96CSAoK11Ngud9=n1U-Q@mail.gmail.com>
 <20170124174907.GA27340@vader>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 24 Jan 2017 11:37:43 -0700
Message-ID: <CAJCQCtQVYdc9JK_B=XCrTBE6YYjqz23D3rEmRLoJUbM7gQVQSQ@mail.gmail.com>
Subject: Re: read-only fs, kernel 4.9.0, fs/btrfs/delayed-inode.c:1170 __btrfs_run_delayed_items,
To: Omar Sandoval <osandov@osandov.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, agruenba@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 24, 2017 at 10:49 AM, Omar Sandoval <osandov@osandov.com> wrote:
> On Mon, Jan 23, 2017 at 08:51:24PM -0700, Chris Murphy wrote:
>> On Mon, Jan 23, 2017 at 5:05 PM, Omar Sandoval <osandov@osandov.com> wrote:
>> > Thanks! Hmm, okay, so it's coming from btrfs_update_delayed_inode()...
>> > That's probably us failing btrfs_lookup_inode(), but just to make sure,
>> > could you apply the updated diff at the same link as before
>> > (https://gist.github.com/osandov/9f223bda27f3e1cd1ab9c1bd634c51a4)? If
>> > that's the case, I'm even more confused about what xattrs have to do
>> > with it.
>>
>> [   35.015363] __btrfs_update_delayed_inode(): inode is missing
>
> Okay, like I expected...
>
>> [   35.015372] btrfs_update_delayed_inode(ino=2) -> -2
>
> Wtf? Inode numbers should be >=256. I updated the diff a third time to
> catch where that came from. If we're lucky, the backtrace should have
> the exact culprit. If we're unlucky, there might be memory corruption
> involved.

Now two traces. This one is new, and follows a bunch of xattr related stuff...

[    6.861504] WARNING: CPU: 3 PID: 690 at fs/btrfs/delayed-inode.c:55
btrfs_get_or_create_delayed_node+0x16a/0x1e0 [btrfs]
[    6.862833] ino 2 is out of range

Then this:
[    7.016061] __btrfs_update_delayed_inode(): inode is missing
[    7.017149] btrfs_update_delayed_inode() failed
[    7.018233] __btrfs_commit_inode_delayed_items(ino=2, flags=3) -> -2

And finally what we've already seen:
[   34.930890] WARNING: CPU: 0 PID: 396 at
fs/btrfs/delayed-inode.c:1194 __btrfs_run_delayed_items+0x1d0/0x670
[btrfs]

Complete dmesg osandov-9f223b-3_dmesg.log
https://drive.google.com/open?id=0B_2Asp8DGjJ9bnpNamIydklraTQ

Also, to do these tests, I'm making a new rw snapshot each time so
that the new kernel modules are in the snapshot. e.g.

1. subvolumes 'home' and 'root' are originally created with 'btrfs sub
create' and then filled, and these work OK with all kernels.
2. build kernel with patch
3. 'btrfs sub snap root root.test8'  and also 'btrfs sub snap home home.test8'
4. sudo vi root.test8/etc/fstab to update the entry for / so that
subvol=root is now subvol=root.test8, and also update for /home
5. sudo vi /boot/efi/EFI/fedora/grub.cfg to update the command line,
rootflags=subvol=root becomes rootflags=subvol=root.test8

So the fact the kernel works on subvolume root, but consistently does
not work on each brand new snapshot, is suspiciously unlike what I'd
expect for memory corruption; unless the memory corruption has already
"tainted" the file system in a way that neither btrfs check or scrub
can find; and this "taintedness" of the file system doesn't manifest
until there's a snapshot being used and with a particular kernel with
the xattr patch?

Pretty weird.


-- 
Chris Murphy
