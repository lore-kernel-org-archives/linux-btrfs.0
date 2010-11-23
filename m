From: C Anthony Risinger <anthony@extof.me>
Subject: Re: btrfs problems and fedora 14
Date: Tue, 23 Nov 2010 00:45:02 -0600
Message-ID: <AANLkTimkdtmjeO1Hzq5y1nL_ERNiJS1S0xn6Vu2_yyj=@mail.gmail.com>
References: <1290467983.24502.66.camel@main-wireless>
	<AANLkTinuQU46BCL6WLM4hEc+ocXsbOGHoF3ppGbTOc8y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: david grant <dg@david-grant.com>, linux-btrfs@vger.kernel.org
To: Wenyi Liu <qingshenlwy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinuQU46BCL6WLM4hEc+ocXsbOGHoF3ppGbTOc8y@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 22, 2010 at 10:47 PM, Wenyi Liu <qingshenlwy@gmail.com> wro=
te:
> 2010/11/23, david grant <dg@david-grant.com>:
>> I thought I would try btrfs on a new installation of f14. yes, I kno=
w
>> its experimental but stable so it seemed to be a good time to try it=
=2E
>> I am not sure if I have missed something out of all my searching but=
 am
>> I correct in thinking that currently:
>> =A0 =A0 =A0I. it is not possible to boot from a snapshot of the oper=
ating
>> =A0 =A0 =A0 =A0 system and, in particular, the yum snapshots cannot =
be used for
>> =A0 =A0 =A0 =A0 that purpose
>
> Is the Fedora grub support btrfs now?
> In this page http://fedoraproject.org/wiki/Features/SystemRollbackWit=
hBtrfs
> I got the following information:
> (deferred) a patch to grub1 -- on top of the already existing patch t=
o
> support btrfs in grub1 -- to allow selecting between snapshots of the
> boot partition.

all you need to do is add:

subvol=3D<name of the snapshot>

-- or --

subvolid=3D<id of the snapshot>

to your kernel boot line (edit in grub on the fly)... however, if
fedora is like archlinux in this respect (brief google search seems to
agree), you will actually need to add this:

rootflags=3Dsubvol=3D<name of the snapshot>

where `rootflags` are the mount options passed to the initramfs/root
device.  also, you reeeeally don't need grub, whatsoever[1]; in arch,
we use an initramfs hook to perform system rollback by dynamically
modifying the rootflags in accordance with the user's choice:

http://aur.archlinux.org/packages/mkinitcpio-btrfs/mkinitcpio-btrfs/btr=
fs_hook

perhaps someone in fedora can adapt that script... it's rather simple,
and it's MUCH easier and safer than fiddling with grub legacy[1].

C Anthony

[1] note however, that a proper grub2/extlinux solution is ideal to
support kernel-level rollbacks.  in the link above, everything is
rolled back except the kernel (residing on /boot... non-btrfs).
though, a kexec solution may be possible.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
