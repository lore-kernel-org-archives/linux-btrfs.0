From: david grant <dg@david-grant.com>
Subject: Re: btrfs problems and fedora 14
Date: Wed, 24 Nov 2010 18:32:33 +1100
Message-ID: <1290583953.2235.28.camel@main-wireless>
References: <1290467983.24502.66.camel@main-wireless>
	 <AANLkTinuQU46BCL6WLM4hEc+ocXsbOGHoF3ppGbTOc8y@mail.gmail.com>
	 <AANLkTimkdtmjeO1Hzq5y1nL_ERNiJS1S0xn6Vu2_yyj=@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Wenyi Liu <qingshenlwy@gmail.com>, linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@extof.me>,
	Hugo Mills <hugo-lkml@carfax.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTimkdtmjeO1Hzq5y1nL_ERNiJS1S0xn6Vu2_yyj=@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Thank you all for your responses to my boot snapshot problem but it
still exists.
.
Hugo, you told me how to mount a snapshot. Thank you, that works but you
didn't tell me how to boot into it.

Anthony, I really hoped that you had provided the answer using grub but
all combinations of your suggestions result in a boot failure with
standard error message of unable to mount root because of of wrong fs
type etc. I assume that with your suggestion I need a standard fstab
entry with default options but it doesn't work even with subvol options.
I am always nervous of messing with the MBR so I want to stick with
grub.

Perhaps this is a fedora problem but I have to say I find it very
strange that they tout btrfs as the future, particularly with respect to
rollbacks but provide no guide to doing this. I assume it is a
combination of grub boot parameters and fstab but nobody seems to know
what to do.

I am not a techo so I just need simple instructions. Is there any other
site, I should be posting this on?

Thanks in anticipation


On Tue, 2010-11-23 at 00:45 -0600, C Anthony Risinger wrote: 
> On Mon, Nov 22, 2010 at 10:47 PM, Wenyi Liu <qingshenlwy@gmail.com> wrote:
> > 2010/11/23, david grant <dg@david-grant.com>:
> >> I thought I would try btrfs on a new installation of f14. yes, I know
> >> its experimental but stable so it seemed to be a good time to try it.
> >> I am not sure if I have missed something out of all my searching but am
> >> I correct in thinking that currently:
> >>      I. it is not possible to boot from a snapshot of the operating
> >>         system and, in particular, the yum snapshots cannot be used for
> >>         that purpose
> >
> > Is the Fedora grub support btrfs now?
> > In this page http://fedoraproject.org/wiki/Features/SystemRollbackWithBtrfs
> > I got the following information:
> > (deferred) a patch to grub1 -- on top of the already existing patch to
> > support btrfs in grub1 -- to allow selecting between snapshots of the
> > boot partition.
> 
> all you need to do is add:
> 
> subvol=<name of the snapshot>
> 
> -- or --
> 
> subvolid=<id of the snapshot>
> 
> to your kernel boot line (edit in grub on the fly)... however, if
> fedora is like archlinux in this respect (brief google search seems to
> agree), you will actually need to add this:
> 
> rootflags=subvol=<name of the snapshot>
> 
> where `rootflags` are the mount options passed to the initramfs/root
> device.  also, you reeeeally don't need grub, whatsoever[1]; in arch,
> we use an initramfs hook to perform system rollback by dynamically
> modifying the rootflags in accordance with the user's choice:
> 
> http://aur.archlinux.org/packages/mkinitcpio-btrfs/mkinitcpio-btrfs/btrfs_hook
> 
> perhaps someone in fedora can adapt that script... it's rather simple,
> and it's MUCH easier and safer than fiddling with grub legacy[1].
> 
> C Anthony
> 
> [1] note however, that a proper grub2/extlinux solution is ideal to
> support kernel-level rollbacks.  in the link above, everything is
> rolled back except the kernel (residing on /boot... non-btrfs).
> though, a kexec solution may be possible.


