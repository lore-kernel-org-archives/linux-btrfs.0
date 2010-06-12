From: C Anthony Risinger <anthony@extof.me>
Subject: Re: Music-files suddenly not recognized anymore, empty files -
	Btrfschk reports errors
Date: Sat, 12 Jun 2010 15:50:46 -0500
Message-ID: <AANLkTimQyAEJd_-gLK8V65v6AKvmqUVDoYm9odiASQFO@mail.gmail.com>
References: <AANLkTim4wf0p5KP29Usd8cp6YOQzR3oiqpPTFl1NoVTP@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Clemens Eisserer <linuxhippy@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTim4wf0p5KP29Usd8cp6YOQzR3oiqpPTFl1NoVTP@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 12, 2010 at 3:40 PM, Clemens Eisserer <linuxhippy@gmail.com=
> wrote:
> Hi,
>
> Recently Amarok started to reject some of music files.
> Some files seem to be simply corrupted (mplayer is still able to play
> them), other have zero length.
>
> Btrfsck reports:
> root 5 inode 1371 errors 400
> found 42498768896 bytes used err is 1
> total csum bytes: 41015664
> total tree bytes: 498728960
> total fs tree bytes: 406466560
> btree space waste bytes: 110792472
> file data blocks allocated: 271306133504
> =A0referenced 46886879232
> Btrfs Btrfs v0.19
>
>
> Anything I can do to repair those errors?

have you taken any snapshots?  you could pull them from there maybe.

btrfsck is not able to repair anything yet.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
