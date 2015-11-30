Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:5514 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752111AbbK3CAP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Nov 2015 21:00:15 -0500
Subject: Re: shall distros run btrfsck on boot?
To: Jeff Mahoney <jeffm@suse.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        <linux-btrfs@vger.kernel.org>
References: <1448337754.14125.33.camel@scientia.net>
 <5659DBD9.1070802@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <565BAD9C.4040002@cn.fujitsu.com>
Date: Mon, 30 Nov 2015 09:59:56 +0800
MIME-Version: 1.0
In-Reply-To: <5659DBD9.1070802@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Jeff Mahoney wrote on 2015/11/28 11:52 -0500:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA256
>
> On 11/23/15 11:02 PM, Christoph Anton Mitterer wrote:
>> Hey.
>>
>> Short question since that came up on debian-devel.
>>
>> Now that btrfs check get's more and more useful, are the
>> developers going to recommend running it periodically on boot (of
>> course that wouldn't work right now, as it would *always* check)?
>
> Running fsck on boot is a holdover from an era where non-journaling
> file systems were the norm.  It persists in the ext* world mostly due
> to inertia, but it shouldn't be run on boot with ext3 or ext4 either.
>   As Eric noted, fsck.xfs is a no-op.  We have something similar for
> btrfs and have no intention of ever running fsck on boot with btrfs
> except in the case of a mount failure of the root file system.
>
>> Plus... is btrfs check (without any arguments) non-desctructive, or
>> are there corner-cases where it may lead to any changes on the
>> devices?
>
> I haven't reviewed it in detail, but a quick glance makes it look like
> it will, minimally, create transactions even in check-only mode.

This seems interesting.

Any clue to enhance?

Thanks,
Qu
>
> - -Jeff
>
> - --
> Jeff Mahoney
> SUSE Labs
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG/MacGPG2 v2
>
> iQIcBAEBCAAGBQJWWdvZAAoJEB57S2MheeWyH9IP/3fYiURQ//xy4QHxUqztiR2h
> NrX+I2n7cnaK3jxhgSQ4snFMzQqxpyjDdV3bTy6kqfBIhvrXKGVQdyFG0SV1MNuJ
> WJuJYCzQa81mDP3G2T3I3sN7oFndIctKaDNBJ5VVCes/W7sFm3JTTfRRmPm7rhNw
> GeFTnKFaZ39Lc53VOR7nX3vDKeGWzyyl2WGYYQ2uq7CKIn3jW1Pi5PKEysq21d8W
> zsDjMh3PfI/TkI4BvNZkyoQaQPaMPZrK0rvY0ke3ScKh5W9MO9zZwcheT79gBRS/
> MPtyOdWVtslDwdurgPyi9fX4bFlPQ6vqBy3evFeYBhuujypX49T8xZGUSIWUvXli
> ElGm80S/+UWGWMl968BcoAp/rrQTfnZcYPHV4YZaeRRwdli5z82gRQsB5OYsQd1w
> AlKJ3uq5mFu/qbWYgM3d51tr+OwZOSCDp9Ofj41Da7P1YmGDC10BP8hlm/YiDP91
> sRCPF8Y9vy9F6wkCH0xX416CoR/jmB1xKgNiVs64laMfznLBprgGxpTh0/Eh6jjS
> aXvtPyJjsidjIXBygzXVDHcSkZT6B881wWhKmDhLiSd5iQqfEnelbOB4gP7ew92X
> QbATRfjIPqCPfLS3S2mOlewq+IbFBvX6TkDzqyGjyST66h3MgayD1nADNGMOauV7
> aFaeWgGFGM1gcqDS/7vY
> =eiA7
> -----END PGP SIGNATURE-----
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


