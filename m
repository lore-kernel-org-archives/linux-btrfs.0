From: Chester <somethingsome2000@gmail.com>
Subject: Re: Root fs on raid1
Date: Thu, 18 Nov 2010 00:32:39 -0600
Message-ID: <AANLkTi=9dncPp-aX=4WmTpttWs1jjq9KKtVLNaBitGf8@mail.gmail.com>
References: <GM8zfnmgV9SK.SwXVG4nX@mail.prnet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: admin@prnet.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <GM8zfnmgV9SK.SwXVG4nX@mail.prnet.org>
List-ID: <linux-btrfs.vger.kernel.org>

You might need to build an initramfs image for your kernel to mount,
to help mount your btrfs filesystem. You may want to read Gentoo's
guide for initramfs

http://en.gentoo-wiki.com/wiki/Initramfs

On Thu, Nov 18, 2010 at 12:14 AM,  <admin@prnet.org> wrote:
> Hi,
>
> I have read that for using raid1 btrfs device scan must be run before=
 mounting the fs. How do I proceed if root filesystem is mounted from b=
trfs ?
>
> Thanks in advance
> Bye,
> David Arendt
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
