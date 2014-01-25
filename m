Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:64171 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbaAYIut (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jan 2014 03:50:49 -0500
Received: by mail-wg0-f52.google.com with SMTP id b13so3894390wgh.7
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jan 2014 00:50:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CA+TwyweCeUQ7w5MuRLrfHfmJwDbChX5VodsyW8huQ9YuLOAWQA@mail.gmail.com>
References: <20140125070415.GB14998@merlins.org>
	<CA+TwyweCeUQ7w5MuRLrfHfmJwDbChX5VodsyW8huQ9YuLOAWQA@mail.gmail.com>
Date: Sat, 25 Jan 2014 21:50:48 +1300
Message-ID: <CA+TwywcetN9Cy_SoKvq9rc7XQJVWERbFehCE1Bhn=Jz81SEGJg@mail.gmail.com>
Subject: Fwd: Is there a lightweight copy from one subvolume to another?
From: Maxdamantus <maxdamantus@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

---------- Forwarded message ----------
From: Maxdamantus <maxdamantus@gmail.com>
Date: 25 January 2014 21:49
Subject: Re: Is there a lightweight copy from one subvolume to another?
To: Marc MERLIN <marc@merlins.org>


Due to what I understand is some VFS limitation, you can only
reflink-copy between subvolumes under one Linux mountpoint. If
/mnt/btrfs1 provides access to all subvolumes, you should be able to
copy between them through that path, but you won't be able to copy
them across mounts, even `--bind` ones.

On 25 January 2014 20:04, Marc MERLIN <marc@merlins.org> wrote:
> If I have
> /mnt/btrfs1/subvol1
> /mnt/btrfs1/subvol2
>
> Can I copy/move data from subvol1 to subvol2 without having to physically
> copy all the blocks as if it were an entirely different filesystem?
>
> reflink doesn't work for this:
> gargamel [mc]# cp -av --reflink=always misc/olympic Video/misc/
> `misc/olympic' -> `Video/misc/olympic'
> `misc/olympic/file.avi' -> `Video/misc/olympic/file.avi'
> cp: failed to clone `Video/misc/olympic/file.avi' from `misc/olympic/file.avi': Invalid cross-device link
>
> Was there another way?
>
> Thanks,
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
