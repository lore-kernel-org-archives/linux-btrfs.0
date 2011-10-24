From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Snapshot rollback
Date: Mon, 24 Oct 2011 19:11:49 +0700
Message-ID: <CAG1y0sc_2+NZm0o8Ng_kyjWgZLZZ3SaJ3=5-0SG2_4r1tKjwoQ@mail.gmail.com>
References: <4EA46E3A.9090307@cfl.rr.com>
	<loom.20111024T071806-3@post.gmane.org>
	<CAG1y0sfmnD8W7an-7HicwfH0HuzJA4wnOLq90qn5iTJmEs4v0w@mail.gmail.com>
	<loom.20111024T101858-236@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20111024T101858-236@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 24, 2011 at 3:24 PM, dima <dolenin@parallels.com> wrote:
> Fajar A. Nugraha <list <at> fajar.net> writes:
>
>> A problem with that, though, if you decide to put /boot on btrfs as
>> well. Grub uses the default subvolume to determine paths (for kernel,
>> initrd, etc). A workaround is to manually create and manage your
>> grub.cfg (or create and use a manual-managed include file, like
>> custom-top.cfg, that gets parsed before the automatically created
>> entries).
>
> Oops, sorry, I was incorrect of course. Thanks Fajar.
> I do have /boot in my subvolid=0 because bootloaders can't read inside
> subvolumes (other than the default) as far as I understand.
> And I just bind /boot through fstab.

AFAIK you have three possible ways to use /boot on btrfs:

(1) put /boot on subvolid=0, don't change the default subvolume. That
works, but all your snapshot/subvols will be visible under /boot. Some
people might not want that for estetic reason.

(2) put /boot (or /, when /boot is part of / ) on a subvolume, then
change the default subvolume. This works cleanly, but there were some
problems in the past when changing the default subvolume (at least I
had problem). Current kernel version might not have this problem
anymore (I haven't tried again)

(3) put /boot on a subvolume, do not change the default subvolume, and
manage grub.cfg manually. This is what I currently do.

I wish grub's btrfs support is more like zfs support, where both the
bootloader and tools (e.g. update-grub, grub-probe, etc) can
intellegently recognize what dataset /boot is on, and create the
correct entry. For example, if you have this

# df -h /boot
Filesystem            Size  Used Avail Use% Mounted on
rpool/ROOT/ubuntu-1   384G  1.2G  383G   1% /
rpool/ROOT/ubuntu-1/boot
                      383G   71M  383G   1% /boot

... then grub.cfg will have an entry like this

	zfs-bootfs ($root) bootfs
	linux	/ROOT/ubuntu-1/boot/@/vmlinuz-2.6.38-10-generic root=/dev/sda5
ro boot=zfs $bootfs rpool=rpool bootfs=rpool/ROOT/ubuntu-1
	initrd	/ROOT/ubuntu-1/boot/@/initrd.img-2.6.38-10-generic

This flexibility allows me (for example) to have multiple version of
kernel, initrd, and root fs in different datasets, all selectable
during boot process (possibly by manually editing grub command line to
suplly the correct path/argument). Good for rescue purposes, just in
case a recent update made the system broken :)

The closest thing we can get to that with btrfs is currently option
(1), as option (2) requires you to boot to an alternate environment
(e.g live cd) to change the default subvol first.

-- 
Fajar
