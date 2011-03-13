From: =?ISO-8859-1?Q?J=E9r=F4me_Poulin?= <jeromepoulin@gmail.com>
Subject: Re: Btrfs system won't start on Ubuntu (relationship problems...)
Date: Sun, 13 Mar 2011 12:39:48 -0400
Message-ID: <AANLkTi=hprS=QbxR8xCVc7pZ54NTnpvu2MufQBdD4nw2@mail.gmail.com>
References: <AANLkTi=4VaXSZgeN-DeohPduQ_8FiuEroNpKCD3bTSPK@mail.gmail.com>
 <20110313114616.8860.qmail@stuge.se> <AANLkTimtN0FWG95dzjwzOzZoQaHEzL7t5ffZchR=BZAu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimtN0FWG95dzjwzOzZoQaHEzL7t5ffZchR=BZAu@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Re-send as non-HTML
On Sun, Mar 13, 2011 at 7:46 AM, Peter Stuge <peter@stuge.se> wrote:
>
> Pau Iranzo wrote:
> > I installed Ubuntu on my girlfriend's laptop using btrfs as a
> > filesystem. But a few weeks ago something happened: the system
> > wouldn't boot and always show these messages:
> > http://dl.dropbox.com/u/120126/btrfs/IMG_20110313_122119.jpg
> > http://dl.dropbox.com/u/120126/btrfs/IMG_20110313_122125.jpg
> > http://dl.dropbox.com/u/120126/btrfs/IMG_20110313_122143.jpg
>
> The hard drive is broken.
>
> This would have happened at the same point in time regardless of
> btrfs or not, and regardless of Linux or not.
>

Just to confirm, the hard disk is broken, I guess you installed Ubuntu
first because Windows was getting slow, it probably was the hard disk
at this time.

>
> > The problem is that there is now way to mount that partition and all
> > the analysis tools don't give any information. I know there is no fsck
> > for btrfs, so it is just a shame for me, because my girlfriend is
> > really angry at me for this.
> >
> > Foremost is not able to recover files neither.
> >
> > Could anyone help me on this? I don't mind if the system does not
> > start, but I need to recover some files (pictures basically).
>
> Take out the disk from the machine. Get a USB-adapter. Prepare for
> running dd_rescue on another Linux system. Hook up broken drive. Run
> dd_rescue to make a copy of the disk that you can work on. Disconnect
> broken drive. Every second it is powered the chance to recover data
> decreases. Only power it up when you must, and when you are well
> prepared to extract complete contents from the disk. Try to analyze
> how the btrfs is broken. Try to fix it. Mount and recover data.
>
> Meanwhile buy new hard drive and reinstall a system so your friend
> has a working computer.
>

Never plug a defective drive on USB if it is the source, only the
destination can be plugged USB, else defective sectors get transferred
as good filled with random stuff and it only makes data recovery
worst, also, there is ddrescue and dd_rescue, you try both, just make
sure you save a logfile, I don't remember if dd_rescue has one.

>
> //Peter
>
