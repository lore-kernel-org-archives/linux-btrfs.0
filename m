From: dima <dolenin@parallels.com>
Subject: Re: Snapshot rollback
Date: Tue, 25 Oct 2011 02:00:43 +0000 (UTC)
Message-ID: <loom.20111025T034412-244@post.gmane.org>
References: <4EA46E3A.9090307@cfl.rr.com> <loom.20111024T071806-3@post.gmane.org> <CAG1y0sfmnD8W7an-7HicwfH0HuzJA4wnOLq90qn5iTJmEs4v0w@mail.gmail.com> <loom.20111024T101858-236@post.gmane.org> <CAG1y0sc_2+NZm0o8Ng_kyjWgZLZZ3SaJ3=5-0SG2_4r1tKjwoQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Fajar A. Nugraha <list <at> fajar.net> writes:

> AFAIK you have three possible ways to use /boot on btrfs:
> 
> (1) put /boot on subvolid=0, don't change the default subvolume. That
> works, but all your snapshot/subvols will be visible under /boot. Some
> people might not want that for estetic reason.

Hi Fajar,
I think I am doing just this, but my subvolumes are not visible under /boot. I
have all my subvolumes set up like this:
/path/to/subvolid_0/boot       < a simple directory bind-mounted to /
/path/to/subvolid_0/__active   < my / subvolume
/path/to/subvolid_0/__home     < my /home subvolume


> (3) put /boot on a subvolume, do not change the default subvolume, and
> manage grub.cfg manually. This is what I currently do.

Could you elaborate about this option pls., and if possible post your grub.cfg?
I don't quite understand how it works. Though I am doing syslinux at the moment,
I think the process is the same.

thanks
~dima

