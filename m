From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Snapshot rollback
Date: Tue, 25 Oct 2011 15:01:39 +0700
Message-ID: <CAG1y0sfk3TozN0-das7et0StL5pcFFLv4tn3XHKxG56xftuPEA@mail.gmail.com>
References: <4EA46E3A.9090307@cfl.rr.com>
	<loom.20111024T071806-3@post.gmane.org>
	<CAG1y0sfmnD8W7an-7HicwfH0HuzJA4wnOLq90qn5iTJmEs4v0w@mail.gmail.com>
	<loom.20111024T101858-236@post.gmane.org>
	<CAG1y0sc_2+NZm0o8Ng_kyjWgZLZZ3SaJ3=5-0SG2_4r1tKjwoQ@mail.gmail.com>
	<loom.20111025T034412-244@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20111025T034412-244@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 25, 2011 at 9:00 AM, dima <dolenin@parallels.com> wrote:
> Fajar A. Nugraha <list <at> fajar.net> writes:
>
>> AFAIK you have three possible ways to use /boot on btrfs:
>>
>> (1) put /boot on subvolid=3D0, don't change the default subvolume. T=
hat
>> works, but all your snapshot/subvols will be visible under /boot. So=
me
>> people might not want that for estetic reason.
>
> Hi Fajar,
> I think I am doing just this, but my subvolumes are not visible under=
 /boot. I
> have all my subvolumes set up like this:
> /path/to/subvolid_0/boot =A0 =A0 =A0 < a simple directory bind-mounte=
d to /
> /path/to/subvolid_0/__active =A0 < my / subvolume
> /path/to/subvolid_0/__home =A0 =A0 < my /home subvolume

Actually with that setup you're using option (3) that I described.

That means all your subvolumes is still visible under
/path/to/subvolid_0/, right? I'm not sure how well grub can manage
this. Probably it can't, so you'd have to manage boot entries
manually.

>
>
>> (3) put /boot on a subvolume, do not change the default subvolume, a=
nd
>> manage grub.cfg manually. This is what I currently do.
>
> Could you elaborate about this option pls., and if possible post your=
 grub.cfg?
> I don't quite understand how it works. Though I am doing syslinux at =
the moment,
> I think the process is the same.

=46or example, with the following subvolume sturcture (using default
subvolid 0, unchanged)

/
/boot
/root
/home

=2E.. and fstab set to mount subvol "boot" on /boot. Then when grub
looks for kernels and initrd it'd see that /boot is it's own block
device, so it's use /vmlinuz and /initrd in grub.cfg.

However, when grub actually boots, it'd see the files located an
/boot/vmlinuz and /boot/initrd, and when reading the configuration
it'd be unable to find the files (since from grub's point of view
there's nothing on /vmlinuz and /initrd). Which is why I said you'd
need to manage grub.cfg manually in this setup.



=46or comparison purposes, I'd just setup two versions of Ubuntu with
zfs / and /boot. In a way it's kinda like having different linux
distros/versions installed on different partitions with one master
bootloader choosing which partition is active. Each distro/version can
manage it's own boot configuration file without disturbing each other
(e.g. oneiric won't be able to see natty's kernel and initrd).
Although the initial setup is done manually, each version's grub will
be able to manage it's own kernels and initrd independently. The setup
is something like this:

# zfs list | grep boot
rpool/ROOT/oneiric/boot             23.3M   369G  23.3M
/rpool/ROOT/oneiric/boot
rpool/ROOT/natty/boot             121M   369G  96.3M  /rpool/ROOT/natty=
/boot
rpool/boot                          1.32M   369G  1.32M  /rpool/boot

rpool/boot is where the "master" configuration file for grub is
installed. It's job is to select which configfile (oneiric or natty)
to use next, so it's something like this

#=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
# cat /rpool/boot/grub/grub.cfg
insmod part_msdos
insmod zfs

search --no-floppy --fs-uuid --set=3Droot c4f4006ef59df197
set timeout=3D1

menuentry 'Ubuntu Natty boot menu' {
	configfile	/ROOT/natty/boot/@/grub/grub.cfg
}
menuentry 'Ubuntu Oneiric boot menu' {
	configfile	/ROOT/oneiric/boot/@/grub/grub.cfg
}
#=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


Each Ubuntu version has it's own /boot directory, which will be
mountted as /boot when it's active, but remains unmounted (or mounted
in alternate path) when it's inactive. grub's zfs support will use
dataset name as part of path (regardless where it's currently
mounted), so the config for oneiric looks something like this

#=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
menuentry 'Ubuntu, with Linux 3.0.0-12-generic' --class ubuntu --class
gnu-linux --class gnu --class os {
	search --no-floppy --fs-uuid --set=3Droot c4f4006ef59df197
	linux	/ROOT/oneiric/boot/@/vmlinuz-3.0.0-12-generic root=3D/dev/sda5 r=
o
boot=3Dzfs boot=3Dzfs rpool=3Drpool bootfs=3Drpool/ROOT/oneiric
	initrd	/ROOT/oneiric/boot/@/initrd.img-3.0.0-12-generic
}
#=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


Unfortunately this kind of setup is currently not possible with btrfs.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
