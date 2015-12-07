Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.18]:55094 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbbLGOME (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Dec 2015 09:12:04 -0500
Subject: Re: [PATCH] btrfs: Enhance super validation check
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>
References: <1449477555-10333-1-git-send-email-quwenruo@cn.fujitsu.com>
 <566571F0.2010002@googlemail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <5665938F.7040508@gmx.com>
Date: Mon, 7 Dec 2015 22:11:27 +0800
MIME-Version: 1.0
In-Reply-To: <566571F0.2010002@googlemail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/07/2015 07:48 PM, Holger Hoffstätte wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 12/07/15 09:39, Qu Wenruo wrote:
> (..)
>> +#define BTRFS_SUPER_FLAG_METADUMP_V2	(1ULL << 34)
>
> It looks like you diffed from a tree that has Josef's patch
> called "Btrfs: add metadump_v2 support to the kernel" [1] applied,
> which never made it upstream (probably got lost in the 4.0 mess).
> This patch is not yet in 4.4rc, so merging your patch will introduce
> half of Josef's patch but with the bits in inode.c missing.

It's based from integration-4.4.

This bit is copied from btrfs-progs.
And I added this is to make kernel accept such dump image as it used to.
(Along with fsid chaning image)

Not sure about the inode part.
But I added this just to keep the same behavior for such images.
>
> cc:'ing Chris to make sure he applies that missing patch as well.

And if Josef's patch can be merged into kernel, that would be best.

Thanks,
Qu

>
> cheers,
> Holger
>
> [1] http://www.spinics.net/lists/linux-btrfs/msg41973.html
>
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2
>
> iEYEARECAAYFAlZlcewACgkQD4E0Cdjc7s2AjACeJKjfyJDRQBVM9y2j90MaZhjX
> ynwAn0oKMM9MTZ4I8cmuxnHGgj3ZeSv4
> =Jb6u
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
