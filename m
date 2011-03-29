From: Andrew Lutomirski <luto@mit.edu>
Subject: Re: How to remove a device on a RAID-1 before replacing it?
Date: Tue, 29 Mar 2011 17:01:39 -0400
Message-ID: <AANLkTimXOFpfWS=8bxLyYiPLS_qBFbWG-g8VKsxLMEcD@mail.gmail.com>
References: <AANLkTinpGXaF_=nZW+uB8zEBG8XPZbwrn+HW48JG_02P@mail.gmail.com> <AANLkTi=SiesmPbkwoCHSpxDaLK_S8EcZEbBBtVFZUV_j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: cwillu <cwillu@cwillu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=SiesmPbkwoCHSpxDaLK_S8EcZEbBBtVFZUV_j@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 29, 2011 at 4:21 PM, cwillu <cwillu@cwillu.com> wrote:
> On Tue, Mar 29, 2011 at 2:09 PM, Andrew Lutomirski <luto@mit.edu> wro=
te:
>> I have a disk with a SMART failure. =A0It still works but I assume i=
t'll
>> fail sooner or later.
>>
>> I want to remove it from my btrfs volume, replace it, and add the ne=
w
>> one. =A0But the obvious command doesn't work:
>>
>> # btrfs device delete /dev/dm-5 /mnt/foo
>> ERROR: error removing the device '/dev/dm-5'
>>
>> dmesg says:
>> btrfs: unable to go below two devices on raid1
>>
>> With mdadm, I would fail the device, remove it, run degraded until I
>> get a new device, and hot-add that device.
>>
>> With btrfs, I'd like some confirmation from the fs that data is
>> balanced appropriately so I won't get data loss if I just yank the
>> drive. =A0And I don't even know how to tell btrfs to release the dri=
ve
>> so I can safely remove it.
>>
>> (Mounting with -o degraded doesn't help. =A0I could umount, remove t=
he
>> disk, then remount, but that feels like a hack.)
>
> There's no "nice" way to remove a failing disk in btrfs right now
> ("btrfs dev delete" is more of a online management thing to politely
> remove a perfectly functional disk you'd like to use for something
> else.) =A0As I understand things, the only way to do it right now is =
the
> umount, remove disk, remount w/ degraded, and then btrfs add the new
> device.
>

Well, the disk *is* perfectly functional.  It just won't be for long.

I guess what I'm saying is that either btrfs dev delete isn't really
working -- I want to be able to convert to non-RAID and back or
degraged and back or something else equivalent.

--Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
