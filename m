From: Wenyi Liu <qingshenlwy@gmail.com>
Subject: Re: btrfs problems and fedora 14
Date: Tue, 23 Nov 2010 12:47:43 +0800
Message-ID: <AANLkTinuQU46BCL6WLM4hEc+ocXsbOGHoF3ppGbTOc8y@mail.gmail.com>
References: <1290467983.24502.66.camel@main-wireless>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: david grant <dg@david-grant.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290467983.24502.66.camel@main-wireless>
List-ID: <linux-btrfs.vger.kernel.org>

2010/11/23, david grant <dg@david-grant.com>:
> I thought I would try btrfs on a new installation of f14. yes, I know
> its experimental but stable so it seemed to be a good time to try it.
> I am not sure if I have missed something out of all my searching but am
> I correct in thinking that currently:
>      I. it is not possible to boot from a snapshot of the operating
>         system and, in particular, the yum snapshots cannot be used for
>         that purpose

Is the Fedora grub support btrfs now?
In this page http://fedoraproject.org/wiki/Features/SystemRollbackWithBtrfs
I got the following information:
(deferred) a patch to grub1 -- on top of the already existing patch to
support btrfs in grub1 -- to allow selecting between snapshots of the
boot partition.

>     II. it is so easy to create raid arrays of btrfs partitions but they
>         cannot be read by f13 or f14
>    III. it is not possible to copy btrfs partitions with snapshots
>         except possibly by the use of dd.
> This is not meant to be a put down of btrfs but a plea to have some
> clarification and in particular the ability to boot snapshots.
>
> Hope I can get a response
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
