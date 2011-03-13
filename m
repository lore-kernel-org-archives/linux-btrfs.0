From: cwillu <cwillu@cwillu.com>
Subject: Re: Btrfs system won't start on Ubuntu (relationship problems...)
Date: Sun, 13 Mar 2011 05:46:19 -0600
Message-ID: <AANLkTin8HJTPHKX+UAh7ruMZ6Spd0umt2JO0e5SHLmrB@mail.gmail.com>
References: <AANLkTi=4VaXSZgeN-DeohPduQ_8FiuEroNpKCD3bTSPK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Pau Iranzo <paulists@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=4VaXSZgeN-DeohPduQ_8FiuEroNpKCD3bTSPK@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 13, 2011 at 5:32 AM, Pau Iranzo <paulists@gmail.com> wrote:
> Hi,
>
> I installed Ubuntu on my girlfriend's laptop using btrfs as a
> filesystem. But a few weeks ago something happened: the system
> wouldn't boot and always show these messages:
> http://dl.dropbox.com/u/120126/btrfs/IMG_20110313_122119.jpg
> http://dl.dropbox.com/u/120126/btrfs/IMG_20110313_122125.jpg
> http://dl.dropbox.com/u/120126/btrfs/IMG_20110313_122143.jpg
>
> The problem is that there is now way to mount that partition and all
> the analysis tools don't give any information. I know there is no fsck
> for btrfs, so it is just a shame for me, because my girlfriend is
> really angry at me for this.
>
> Foremost is not able to recover files neither.
>
> Could anyone help me on this? I don't mind if the system does not
> start, but I need to recover some files (pictures basically).

Looks like the drive is shot, although I suppose it could be a bad cable.

What I'd probably do is run a dd_rescue from a livecd or another
system to a second drive, and then try mounting it via "mount
/path/to/file /mnt -o loop -t btrfs" or some such.  Once you have the
image it should be possible to get something back even if it doesn't
mount at that point.

This, in a nutshell, is why I think people are foolish to not have
backups even if they _aren't_ running a filesystem still under active
development.
