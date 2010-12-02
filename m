From: Tommy Jonsson <quazzie@gmail.com>
Subject: Re: Fsck, parent transid verify failed
Date: Thu, 2 Dec 2010 22:49:30 +0100
Message-ID: <AANLkTimuUZM_j-MA0L6rSOOO2TTq=ap8j+=WjCRj6BL8@mail.gmail.com>
References: <003501cb9147$09197540$1b4c5fc0$@gmail.com>
	<1291306826-sup-7837@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: chris.mason@oracle.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1291306826-sup-7837@think>
List-ID: <linux-btrfs.vger.kernel.org>

I'm on kernel 2.6.35

I can't remember if i used -m raid0.
I think i just used "mkfs.btrfs /dev/sda" then "btrfs device add
/dev/sdb" and same for sdc.
I am sure that i didn't explicitly use -m raid1 or raid10.
Is there a way that i can check this ?

If i do have raid0 for both metadata and data is there anything i can d=
o ?
I've been looking at the source but haven't got my head around it yet.

What whould happen if i just ignore/bypass the transid error?

The error:
[265889.197279] device fsid 734a485d12c77872-
9b0b5aa408670db4 devid 3 transid 39651 /dev/sda
[265889.198266] btrfs: use compression
[265889.647817] parent transid verify failed on 2721514774528 wanted
39651 found 39649
[265889.672632] btrfs: open_ctree failed

Or could i update the metadata to want 39649 ?

Thanks again!

On Thu, Dec 2, 2010 at 5:21 PM, Chris Mason <chris.mason@oracle.com> wr=
ote:
>
> Excerpts from Tommy Jonsson's message of 2010-12-01 06:00:56 -0500:
> > Hi folks!
> >
> > Been using btrfs for quite a while now, worked great until now.
> > Got power-loss on my machine and now i have the "parent transid ver=
ify
> > failed on X wanted X found X" problem.
> > So I can't get it to mount.
> >
> > My btrfs is spread over sda (2tb), sdc(2tb), sdd(1tb).
> >
> > Is this something that an offline fsck could fix ?
> > If so is the fsck-util being developed ?
> > Is there a way to mount the FS in a read-only mode or something to =
rescue
> > the data ?
>
> Which kernel are you on? =A0Unless you formatted with -m raid0, the
> current git tree should be able to read this FS by using the second c=
opy
> of the metadata.
>
> -chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
