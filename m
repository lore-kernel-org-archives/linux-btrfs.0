Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52562 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753544AbaCZVOU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Mar 2014 17:14:20 -0400
Message-ID: <53334326.5030705@fb.com>
Date: Wed, 26 Mar 2014 17:14:14 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Johannes Stemmler <jobus@hat-hill.de>, <linux-btrfs@vger.kernel.org>
Subject: Re: Inappropriate ioctl
References: <5333410F.3010000@hat-hill.de>
In-Reply-To: <5333410F.3010000@hat-hill.de>
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/26/2014 05:05 PM, Johannes Stemmler wrote:
> Sorry for reporting this issue to you, but I have not found any helpful
> information elsewhere.
>
> I have installed a new opensuse-system 12.3 from scratch and selected an
> ext4-fs for /
> and btrfs for /home
> The installation works and the access to the /home btrfs works also.
>
> But the btrfs-progs doesn't.
>
> show works
> # btrfs filesystem show /dev/sda8
> Label: lx_home  uuid: 5a6857e3-b421-4a68-92f4-0c7e5f9fcb4c
>          Total devices 1 FS bytes used 74.40GiB
>          devid    1 size 262.63GiB used 77.04GiB path /dev/sda8
>
> df does not work
> # btrfs filesystem df /dev/sda8
> ERROR: couldn't get space info - Inappropriate ioctl for device
> ERROR: get_df failed Inappropriate ioctl for device
>
> #mount
> /dev/sda6 on / type ext4 (rw,relatime,data=ordered)
> /dev/sda8 on /home type btrfs (rw,relatime,ssd,space_cache)
>
> A reinstallation of the btrfs-progs did not help.
> Is the system bad packaged by opensuse or is my constellation forbidden?
>

btrfs filesystem df /home

Josef

