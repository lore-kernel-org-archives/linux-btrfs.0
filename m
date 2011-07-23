From: Victor Stinner <victor.stinner@haypocalc.com>
Subject: Re: Issues with KVM
Date: Sat, 23 Jul 2011 11:20:09 +0200
Message-ID: <4E2A9249.3080006@haypocalc.com>
References: <4E29D318.7050602@haypocalc.com> <CAGAVQTGdEQdS+rE-D=fd4GXgaufpdR6J5xgNUjRa+N402Ge5-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAGAVQTGdEQdS+rE-D=fd4GXgaufpdR6J5xgNUjRa+N402Ge5-g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le 22/07/2011 21:59, C Anthony Risinger a =C3=A9crit :
> ) is the host FS btrfs?
The host (Fedora) FS is btrfs, the VM (Debian) uses ext4 (or maybe ext3=
,=20
I will have to check).
> ) are virtio modules in the initramfs (or kernel probably)?
> ) are you sure virtio is being used (eg. are the disks called vdX vs =
sdX)?
> ) is the disk bus set to virtio (virtmanager)?
I'm not sure. I will have to check.
> ) is the disk's cache mode set to none [or maybe writeback] (virtmana=
ger)?
I don't remember, I will check.

What is the effect of this option? (What is the effect on the host FS=20
(btrfs)?)
> ) is the disk's storage format set to "raw", should be (virtmanager)?
Yes, the image type is "raw".
> ) is caching enabled on the image? ()
What do you mean? Is it possible to enable or disable the cache on a=20
specific file on the host (Fedora, btrfs)? Or you mean set cache to non=
e=20
in the configuration of the VM?
> probably need to change the cache mode on the disk, or if the host is
> btrfs you need to flag the image with whetever is needed to prevent
> continuous COWing.
Can nodatacow option of btrfs have an effect on this issue? Is it=20
possible to set this option for a specific file or directory?

Victor

PS: I have subscribed to the mailing list.

PS2: I'm not at home this week-end, I will check monday.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
