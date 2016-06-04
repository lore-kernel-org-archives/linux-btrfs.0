Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35516 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbcFDBjX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Jun 2016 21:39:23 -0400
Received: by mail-io0-f173.google.com with SMTP id o189so85657486ioe.2
        for <linux-btrfs@vger.kernel.org>; Fri, 03 Jun 2016 18:39:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5751E8D2.7070001@gmail.com>
References: <5751E8D2.7070001@gmail.com>
Date: Fri, 3 Jun 2016 20:39:21 -0500
Message-ID: <CAKZK7uyRSUBp3J=HunPbmFVzLzzH1=QghOD2_p-5+UpyMXuGGg@mail.gmail.com>
Subject: Re: Pointers to mirroring partitions (w/ encryption?) help?
From: Justin Brown <justin.brown@fandingo.org>
To: "B. S." <bs27975@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Here's some thoughts:

> Assume a CD sized (680MB) /boot

Some distros carry patches for grub that allow booting from Btrfs, so
no separate /boot file system is required. (Fedora does not; Ubuntu --
and therefore probably all Debians -- does.)

> perhaps a 200MB (?) sized EFI partition

Way bigger than necessary. It should only be 1-2MiB, and IIRC 2MiB
might be the max UEFI allows.

>  then creates another partition for mirroring, later. IIUC, btrfs add device /dev/sda4 / is appropriate, then. Then running a balance seems recommended.

Don't do this. It's not going to provide any additional protection
that you can't do in a smarter way. If you only have one device and
want data duplication, just use the `dup` data profile (settable via
`balance`). In fact, by default Btrfs uses the `dup` profile for
metadata (and `single` for data). You'll get all the data integrity
benefits with `dup`.

One of the best features and initally confusing things about Btrfs is
how much is done "within" a file system. (There is a certain "the
Btrfs way" to it.)

> Confusing, however, is having those (both) partitions encrypted. Seems some work is needed beforehand. But I've never done encryption.

(This is moot if you go with `dup`.) It's actually quite easy with
every major distro. If we're talking about a fresh install, the distro
installer probably has full support for passphrase-based dm-crypt LUKS
encryption, including multiple volumes sharing a passphrase. An
existing install should be convertable without much trouble. It's
ususally just a matter of setting up the container with `cryptsetup`,
populating `/etc/crypttab`, possibly adding crypto modules to your
initrd and/or updating settings, and rebuilding the initrd. (I have
first-hand experience doing this on a Fedora install recently, and it
took about half an hour and I knew nothing about Fedora's `dracut`
initrd generator tool.)

If you do need multiple encrypted file systems, simply use the same
passphrase for all volumes (but never do this by cloning the LUKS
headers). You'll only need to enter it once at boot.

> The additional problem is most articles reference FDE (Full Disk Encryption) - but that doesn't seem to be prudent. e.g. Unencrypted /boot. So having problems finding concise links on the topics, -FDE -"Full Disk Encryption".

Yeah, when it comes to FDE, you either have to make your peace with
trusting the manufacturer, or you can't. If you are going to boot your
system with a traditional boot loader, an unencrypted partition is
mandatory. That being said, we live in a world with UEFI Secure Boot.
While your EFI parition must be unencrypted vfat, you can sign the
kernels (or shims), and the UEFI can be configured to only boot signed
executables, including only those signed by your own key. Some distros
already provide this feature, including using keys probably already
trusted by the default keystore.

> mirror subvolumes (or it inherently comes along for the ride?)

Yes, that is correct. Just to give some more background: the data and
metadata profiles control "mirroring," and they are set at the file
system level. Subvolumes live entirely within one file system, so
whatever profile is set in the FS applies to subvolumes.

> So, I could take an HD, create partitions as above (how? e.g. Set up encryption / btrfs mirror volumes), then clonezilla (?) partitions from a current machine in.

Are you currently using Btrfs? If so, use Btrfs' `send` and `receive`
commands. That should be lot friendlier to your SSD. (I'll take this
opportunity to say that you need to consider the `discard` mount *and*
`/etc/crypttab` options. Discard -- or scheduling `fstrim` -- is
extremely important to maintain optimal performance of a SSD, but
there are some privacy trade-offs on encrypted systems.) If not, then
`cp -a` or similar will work. Obviously, you'll have to get your boot
mechanism and file system identifiers updated in addition to
`/etc/crypttab` described above.

Lastly, strongly consider `autodefrag` and possibly setting some
highly violatile -- but *unimportant* -- directories to `nodatacow`
via purging and `chattr +C`. (I do this for ~/.cache and /var/cache.)

> Yet not looking to put in a 2nd HD

If you change your mind and decide on a backup device, or even if you
just want local backup snapshots, one of the best snapshot managers is
btrfs-sxbackup (no association with the FS project).

On Fri, Jun 3, 2016 at 3:30 PM, B. S. <bs27975@gmail.com> wrote:
> Hallo. I'm continuing on sinking in to btrfs, so pointers to concise help
> articles appreciated. I've got a couple new home systems, so perhaps it's
> time to investigate encryption, and given the bit rot I've seen here,
> perhaps time to mirror volumes so the wonderful btrfs self-healing
> facilities can be taken advantage of.
>
> Problem with today's hard drives, a quick look at Canada Computer shows the
> smallest drives 500GB, 120GB SSDs, far more than the 20GB or so an OS needs.
> Yet not looking to put in a 2nd HD, either. It feels like mirroring volumes
> makes sense.
>
> (EFI [partitions] also seem to be sticking their fingers in here.]
>
> Assume a CD sized (680MB) /boot, and perhaps a 200MB (?) sized EFI
> partition, it seems to me one sets up / as usual (less complex install),
> then creates another partition for mirroring, later. IIUC, btrfs add device
> /dev/sda4 / is appropriate, then. Then running a balance seems recommended.
>
> Confusing, however, is having those (both) partitions encrypted. Seems some
> work is needed beforehand. But I've never done encryption. I have come
> across https://github.com/gebi/keyctl_keyscript, so I understand there will
> be gotchas to deal with - later. But not there yet, and not real sure how to
> start.
>
> The additional problem is most articles reference FDE (Full Disk Encryption)
> - but that doesn't seem to be prudent. e.g. Unencrypted /boot. So having
> problems finding concise links on the topics, -FDE -"Full Disk Encryption".
>
> Any good links to concise instructions on building / establishing encrypted
> btrfs mirror volumes? dm_crypt seems to be the basis, and not looking to add
> LVM, seems an unnecessary extra layer of complexity.
>
> It also feels like I could mkfs.btrfs /dev/sda3 /dev/sda4, then mirror
> subvolumes (or it inherently comes along for the ride?) - so my confusion
> level increases. Especially if encryption is added to the mix.
>
> So, I could take an HD, create partitions as above (how? e.g. Set up
> encryption / btrfs mirror volumes), then clonezilla (?) partitions from a
> current machine in. I assume mounting a live cd then cp -a from old disk
> partition to new disk partition won't 'just work'. (?)
>
> Article suggestions?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
