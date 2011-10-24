From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Snapshot rollback
Date: Mon, 24 Oct 2011 12:58:20 +0700
Message-ID: <CAG1y0sfmnD8W7an-7HicwfH0HuzJA4wnOLq90qn5iTJmEs4v0w@mail.gmail.com>
References: <4EA46E3A.9090307@cfl.rr.com>
	<loom.20111024T071806-3@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20111024T071806-3@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 24, 2011 at 12:45 PM, dima <dolenin@parallels.com> wrote:
> Phillip Susi <psusi <at> cfl.rr.com> writes:
>
>> I created a snapshot of my root subvol, then used btrfs-subvolume
>> set-default to make the snapshot the default subvol and rebooted. =A0=
This
>> seems to have correctly gotten the system to boot from the snapshot
>> instead of the original subvol, but now /home ( @home subvol ) refus=
es
>> to mount claiming that /dev/sda1 is not a valid block device. =A0Wha=
t gives?

Try mounting using sobvolid. Use "btrfs su li /" (or wherever it's
mounted) to list the ids.

> Personally I do not store anything in subvolid=3D0 directly and never=
 bothered
> with 'set-default' option - just used a new subvolume/snapshot name

+1

A problem with that, though, if you decide to put /boot on btrfs as
well. Grub uses the default subvolume to determine paths (for kernel,
initrd, etc). A workaround is to manually create and manage your
grub.cfg (or create and use a manual-managed include file, like
custom-top.cfg, that gets parsed before the automatically created
entries).

I really like zfs grub2 support, where it will correctly use the
dataset name for file locations. Unfortunately grub's btrfs support
doesn't have it (yet).

> - create a named snapshot
> - edit bootloader config to include the new
> rootflags=3Dsubvol=3D<your_new_snapshot_name>

I had some problem with subvol option in old version of kernel/btrfs
in Lucid/Natty. I use subvolid now, which seems to be more reliable.

--=20
=46ajar
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
