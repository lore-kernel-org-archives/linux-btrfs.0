From: cwillu <cwillu@cwillu.com>
Subject: Re: How to remove a device on a RAID-1 before replacing it?
Date: Tue, 29 Mar 2011 14:21:41 -0600
Message-ID: <AANLkTi=SiesmPbkwoCHSpxDaLK_S8EcZEbBBtVFZUV_j@mail.gmail.com>
References: <AANLkTinpGXaF_=nZW+uB8zEBG8XPZbwrn+HW48JG_02P@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andrew Lutomirski <luto@mit.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinpGXaF_=nZW+uB8zEBG8XPZbwrn+HW48JG_02P@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 29, 2011 at 2:09 PM, Andrew Lutomirski <luto@mit.edu> wrote=
:
> I have a disk with a SMART failure. =A0It still works but I assume it=
'll
> fail sooner or later.
>
> I want to remove it from my btrfs volume, replace it, and add the new
> one. =A0But the obvious command doesn't work:
>
> # btrfs device delete /dev/dm-5 /mnt/foo
> ERROR: error removing the device '/dev/dm-5'
>
> dmesg says:
> btrfs: unable to go below two devices on raid1
>
> With mdadm, I would fail the device, remove it, run degraded until I
> get a new device, and hot-add that device.
>
> With btrfs, I'd like some confirmation from the fs that data is
> balanced appropriately so I won't get data loss if I just yank the
> drive. =A0And I don't even know how to tell btrfs to release the driv=
e
> so I can safely remove it.
>
> (Mounting with -o degraded doesn't help. =A0I could umount, remove th=
e
> disk, then remount, but that feels like a hack.)

There's no "nice" way to remove a failing disk in btrfs right now
("btrfs dev delete" is more of a online management thing to politely
remove a perfectly functional disk you'd like to use for something
else.)  As I understand things, the only way to do it right now is the
umount, remove disk, remount w/ degraded, and then btrfs add the new
device.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
