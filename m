Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbbK3T14 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Nov 2015 14:27:56 -0500
Subject: Re: shall distros run btrfsck on boot?
To: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        linux-btrfs@vger.kernel.org
References: <1448337754.14125.33.camel@scientia.net>
 <5659DBD9.1070802@suse.com> <565BAD9C.4040002@cn.fujitsu.com>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <565CA337.3080609@suse.com>
Date: Mon, 30 Nov 2015 14:27:51 -0500
MIME-Version: 1.0
In-Reply-To: <565BAD9C.4040002@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/29/15 8:59 PM, Qu Wenruo wrote:
> 
> 
> Jeff Mahoney wrote on 2015/11/28 11:52 -0500: On 11/23/15 11:02
> PM, Christoph Anton Mitterer wrote:
>>>> Hey.
>>>> 
>>>> Short question since that came up on debian-devel.
>>>> 
>>>> Now that btrfs check get's more and more useful, are the 
>>>> developers going to recommend running it periodically on
>>>> boot (of course that wouldn't work right now, as it would
>>>> *always* check)?
> 
> Running fsck on boot is a holdover from an era where non-journaling
> file systems were the norm.  It persists in the ext* world mostly
> due to inertia, but it shouldn't be run on boot with ext3 or ext4
> either. As Eric noted, fsck.xfs is a no-op.  We have something
> similar for btrfs and have no intention of ever running fsck on
> boot with btrfs except in the case of a mount failure of the root
> file system.
> 
>>>> Plus... is btrfs check (without any arguments) 
>>>> non-desctructive, or are there corner-cases where it may
>>>> lead to any changes on the devices?
> 
> I haven't reviewed it in detail, but a quick glance makes it look 
> like it will, minimally, create transactions even in check-only 
> mode.
> 
>> This seems interesting.
> 
>> Any clue to enhance?

My glance wasn't close enough.  We only start a transaction after we
check and repair is enabled.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.19 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQIcBAEBAgAGBQJWXKM2AAoJEB57S2MheeWynW4QAJBHbn8Wk+z4hRVfdtg2J6Ot
v3HMaI3kto0Pg1fi87pQKJd3ET/p1ovdTQr2awCBr9hS3Pe5cPGF8Giv+LstWW5G
LWWDaZDYqIJOGx69cwgiYIHxzMf/xn3xoovkrc63b8XjiZa3kUgMbb0cxtnNpXGE
2pa0das4ePZQ54OEfJvOdtdAhwMot1CV9UQaPm1DVJ8eQLAIvQKo4TFtv2y7FlNk
eVfqcK2rM0SHmrx1IcHtd6EBG7yK0zCqPiFLBEU8Zkx3dFDTqsrsa1F2Vgnu7Pm8
LUZekSIUarqQcmM6xZpuZdA+7aOJ2pcCx2aoaYe34QK6U1YHD/Tb+tJNusMMUUdp
z/0NjKmj4ONasbZ9ttZWg4FdDi2eVIRSZ7mYxSv6Gblo7iU/k8WSCzr/VZrnMzXG
idEc9hUUykWdDLYJ7q6EP3/2rApjw/lxLD7peX/+ew9v9ddISbCI+qWO/+ocnPkH
0+v/FkWMFEoaZL5yRkJLfAPNnT4cGEu5n3hjy5Pgxc+1D+eZU+0EtR+0kd8iO/LH
+qrz9RcVLKnPk3dMP6bAznqWz/pmry213AFRl4kTJsv5XDt9oSz4BmhKGU+zG+v6
JPXme3Fl/8GSaRVzTbQ+ALC5vxBL8oFQaV9jY8GA8d24dSXWqDYFLvIjtUNek/r2
gT7Z2612ZTceYX4oFOuk
=32+d
-----END PGP SIGNATURE-----
