From: Chester <somethingsome2000@gmail.com>
Subject: Re: Setting options permanently?
Date: Fri, 27 Jan 2012 17:20:32 -0600
Message-ID: <CAAE6i0gSG4xuyJFQrmfFNh3ojF4GBbsgk7LsN+1XD=9Mp5rSUQ@mail.gmail.com>
References: <4F22BCCC.5090800@danisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Hadmut Danisch <hadmut@danisch.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F22BCCC.5090800@danisch.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 27, 2012 at 9:03 AM, Hadmut Danisch <hadmut@danisch.de> wro=
te:
> Hi,
>
> just a question:
>
> Mounting options for file systems are usually given on the command li=
ne
> or in /etc/fstab.
>
> Both do not work with mobile storage devices like usb hard disks, sin=
ce
> they are either mounted automatically through the desktop, or manuall=
y
> by a user who does not know or remember the mount options for this fi=
le
> system. At least it's error prone.
>
>
>
> What happens if a btrfs is mounted sometimes with and sometimes witho=
ut
> the compression option? I'd guess it generates a mixture of compresse=
d
> and uncompressed files, what is not exactly smart.
>

It should be okay to mount with compress or without compress. Even if
you mount a volume with compressed data without '-o compress' you will
still be able to correctly read the data (but newly written data will
not be compressed)

> Is there a way to set options like compression on a btrfs permanently=
 to
> activate them even when mounted automatically by the desktop or manua=
lly
> by a third person?
>
>
> regards
> Hadmut
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
