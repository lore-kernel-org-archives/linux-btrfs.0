From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Disk space accounting and subvolume delete
Date: Tue, 11 May 2010 08:10:38 +0800
Message-ID: <AANLkTilDHeJ_aRQSKWUTJgIBhlpLHyNRTy4x4ai_MGJI@mail.gmail.com>
References: <20100510182352.GA21154@untroubled.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100510182352.GA21154@untroubled.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 11, 2010 at 2:23 AM, Bruce Guenter <bruce@untroubled.org> w=
rote:
> Hi.
>
> When deleting a snapshot, I have observed that the disk space used by
> that snapshot is not immediately released (according to statvfs or df=
).
> Neither "sync" nor "btrfs filesystem sync" releases the disk space
> neither. =A0The only way I have found to actually fully release the d=
isk
> space is to issue the sync and then sleep until the statvfs free numb=
ers
> stop changing.
>
> This is a rather problematic approach to managing disk space. =A0Is t=
here
> any way to either force a wait until the disk space has been released=
?
>
> My application is automatically managing disk space in the presence o=
f
> snapshots. =A0I allow the disk (a backup) to fill up with snapshots u=
ntil
> it is nearly full, and then to delete snapshots until I have a thresh=
old
> free. =A0However, without the disk space being released promptly and =
no
> way to wait until it is released, the loop can't tell how many snapsh=
ots
> to delete.
>

This is because the snapshot deleting ioctl only removes the a link.
The corresponding tree is dropped in the background by a kernel thread.
We could probably add another ioctl that waits until the tree has been
completely dropped.

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
