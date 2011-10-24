From: dima <dolenin@parallels.com>
Subject: Re: Snapshot rollback
Date: Mon, 24 Oct 2011 08:24:38 +0000 (UTC)
Message-ID: <loom.20111024T101858-236@post.gmane.org>
References: <4EA46E3A.9090307@cfl.rr.com> <loom.20111024T071806-3@post.gmane.org> <CAG1y0sfmnD8W7an-7HicwfH0HuzJA4wnOLq90qn5iTJmEs4v0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fajar A. Nugraha <list <at> fajar.net> writes:
 
> A problem with that, though, if you decide to put /boot on btrfs as
> well. Grub uses the default subvolume to determine paths (for kernel,
> initrd, etc). A workaround is to manually create and manage your
> grub.cfg (or create and use a manual-managed include file, like
> custom-top.cfg, that gets parsed before the automatically created
> entries).

Oops, sorry, I was incorrect of course. Thanks Fajar.
I do have /boot in my subvolid=0 because bootloaders can't read inside
subvolumes (other than the default) as far as I understand.
And I just bind /boot through fstab.

