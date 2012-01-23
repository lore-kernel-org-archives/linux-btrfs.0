From: James <torpesco@gmail.com>
Subject: Re: Single drive volume + second drive -> RAID1?
Date: Mon, 23 Jan 2012 13:17:53 -0800
Message-ID: <CAEPoJ-2Sa2wiJf2osak5vPMYg=FtR=2f0M7vKK6cdopqB=aLwA@mail.gmail.com>
References: <CAEPoJ-1PXu9Pt9E1EEudJ5NN-RunT4POJtjzo=BVRiOn_F97ng@mail.gmail.com>
 <CAEPoJ-34AmiaRpSCk4Whby4gDM6PSKYRyLHmG1my5_WFODaNrQ@mail.gmail.com> <20120123092514.GA5531@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>, James <torpesco@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120123092514.GA5531@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 23, 2012 at 1:25 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> =A0 Why not just create the filesystem as RAID-1 in the first place?
>
> # mkfs.btrfs -d raid1 -m raid1 /dev/sda1 /dev/sdb1

As I said, I've only got two working drives large enough at present.

> =A0 Then you can restore from your backups. You do have backups, righ=
t?
> (Remember, this is a filesystem still marked as "experimental").

Yes, I know. :) I just have remote backups, though, so while I could
go with those I'd prefer to avoid a long download or shipping a drive.

> =A0 Yes, balances are not interruptible right now. The restriper
> patches (in 3.3-rc1) will allow you to monitor balance progress and
> stop/restart them. They will also allow you to change RAID levels on
> the fly, which is what you were asking for in the first place.

Perfect. Since I do have the backup, maybe I'll just wait for that.
Worst case, if I am unlucky enough to find a bad bug, I'll resort to
restoring from the backup. :)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
