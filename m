Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:57604 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933393AbaLEBhW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Dec 2014 20:37:22 -0500
Message-ID: <1417743334.3280.1.camel@localhost.localdomain>
Subject: Re: btrfs fi show not accepting mount path as arg?
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Shriramana Sharma <samjnaa@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Date: Fri, 5 Dec 2014 09:35:34 +0800
In-Reply-To: <CAH-HCWUcMofyaE8pBXRM5LTHjWcabz+DKouVbauH=Oh9fv2g4g@mail.gmail.com>
References: <CAH-HCWUcMofyaE8pBXRM5LTHjWcabz+DKouVbauH=Oh9fv2g4g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2014-12-04 at 19:20 +0530, Shriramana Sharma wrote:
> Using SuSE Tumbleweed. Observe:
> 
> [samjnaa:~] sudo btrfs fi show
> root's password:
> Label: 'BRIHATII'  uuid: 57836428-576e-466b-8a28-7961712867ab
>         Total devices 1 FS bytes used 460.19GiB
>         devid    1 size 931.51GiB used 464.04GiB path /dev/sdb1
> 
> Btrfs v3.17+20141103
> [samjnaa:~] sudo btrfs fi show /dev/sdb1
> Label: 'BRIHATII'  uuid: 57836428-576e-466b-8a28-7961712867ab
>         Total devices 1 FS bytes used 460.16GiB
>         devid    1 size 931.51GiB used 464.04GiB path /dev/sdb1
> 
> Btrfs v3.17+20141103
> [samjnaa:~] mount | grep btrfs
> /dev/sdb1 on /run/media/samjnaa/BRIHATII type btrfs
> (rw,nosuid,nodev,relatime,space_cache,uhelper=udisks2)
> [samjnaa:~] sudo btrfs fi show /run/media/samjnaa/BRIHATII/
> Btrfs v3.17+20141103
> [samjnaa:~]
> 
> But the manpage of btrfs filesystem says that <path> is an acceptable
> argument to show, by which I understand to mean the mounted path of
> the filesystem (or a subvolume thereof?).
> 
> Some problem here?
> 

Hi Shriramana Sharma,

I think this problem has already got a fix, see below:
https://patchwork.kernel.org/patch/5391131/

Thanks,
Gui

