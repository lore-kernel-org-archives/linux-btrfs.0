From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Filesystem corrupted, is there any hope?
Date: Fri, 24 Jun 2011 20:46:19 +0700
Message-ID: <BANLkTi=1Jpc9E-XW8jY6uVYhukMTL2W_vQ@mail.gmail.com>
References: <BANLkTikLCk9=_CgXUWUTf91x7Aiyhuvndg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Michael Stephenson <mickstephenson@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikLCk9=_CgXUWUTf91x7Aiyhuvndg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 24, 2011 at 5:16 PM, Michael Stephenson
<mickstephenson@googlemail.com> wrote:
> Hello,
> I formatted my home partition with btrfs, not realising that the fsck
> tool can't actually fix errors, as I have just discovered on your
> wiki.
> Had I knew this I would have not used it so early, this detail you
> would think would make distributions wary to make it an option on the
> livecd with no warning that if you ever have a power cut you are most
> certainly going to lose your data even if your hardware is fine.
> Anyway is their any hope? Is there beta code for an fsck that can do
> repairs? How long do I have to wait before there is? I can always just
> wait for a few months to get the data back.

That depends on what kind of corruption you have (dmesg / syslog
output would be nice)

For some cases, you can try:
- "btrfsck -s1", and if can finish without errors, try  btrfs-select-super
- if it complains about some transid not available, try btrfs-zero-log

both btrfs-select-super and btrfs-zero-log need to be compiled
manually from source (i.e. "make btrfs-select-super" and "make
btrfs-zero-log"). if you use lzo, you might need the tmp branch
(http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git;a=shortlog;h=refs/heads/tmp)

Some more suggestions:
- when possible, create a copy first of the device (e.g. with
dd_rescue) and work on the copy
- use "mount -o ro", and if readonly mount is successful, copy the
files somewhere safe and recreate your fs.

-- 
Fajar
