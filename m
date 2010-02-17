From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: Kernel BUG on mounting BtrFS / after reboot
Date: Wed, 17 Feb 2010 06:47:28 +0000 (UTC)
Message-ID: <loom.20100217T074453-978@post.gmane.org>
References: <loom.20100212T220341-877@post.gmane.org> <93cdabd21002121450i75586f4ahfe658e4db9204a8e@mail.gmail.com> <loom.20100212T235536-583@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Alex Elsayed <eternaleye <at> gmail.com> writes:

> 
> Mike Fedyk <mfedyk <at> mikefedyk.com> writes:
> 
> > 
> > On Fri, Feb 12, 2010 at 1:04 PM, Alex Elsayed <eternaleye <at> gmail.com> 
> wrote:
> > > I'm getting a rather nasty BUG when I try to mount this filesystem,
> > > _including_ when I specify -o ro. I'm unsure what caused it, but the 
problem
> > > manifested after my computer hardlocked while reading my RSS feeds, 
complete
> > > with flashing lights. After I rebooted it, the screen filled with panic
> > > messages when the initramfs tried to mount it RO to pivot into. I am 
running
> > > 2.6.33-rc6. The BUG message is as follows:
> > 
> > Is this the bug you mentioned on IRC that you fixed somehow?
> > 
> > If so please post the steps you performed.
> 
> No, that bug was on a different hard drive and was due to bad blocks. That 
> instance was converted from ext4, while this is a new mkfs. The steps 
necessary 
> to reproduce the BUG are simple - mount -o ro /dev/Arkadios/Root $mountpoint.
> I'm currently running from my initramfs, with that old system  mounted ro and 
> bound to /usr (since that problem only occurred when writing to the disk, it 
> makes a passable recovery environment).

I have run btrfs-image on the partition, but due to it spanning the better part 
of 500GB (80% full), it's 1.1GB. I therefore can't attach it, but if there's 
somewhere I can FTP or otherwise upload it to so it can be examined, please let 
me know.

