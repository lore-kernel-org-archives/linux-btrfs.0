Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:14511 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbaLSVQF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 16:16:05 -0500
Message-ID: <5494955C.3020603@fb.com>
Date: Fri, 19 Dec 2014 16:15:08 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Daniele Testa <daniele.testa@gmail.com>, Phillip Susi <psusi@ubuntu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs is using 25% more disk than it should
References: <CAN6BF2Luf3ERd+ShLyUavzM3bLmy9dT918Zg17xL9T42DNVtVQ@mail.gmail.com>	<54947432.5010107@ubuntu.com> <CAN6BF2JoMki_KmpmVYVM-_ECqCg_w-qo9_6P=MiZbabMQyVN_g@mail.gmail.com>
In-Reply-To: <CAN6BF2JoMki_KmpmVYVM-_ECqCg_w-qo9_6P=MiZbabMQyVN_g@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/19/2014 02:59 PM, Daniele Testa wrote:
> No, I don't have any snapshots or subvolumes. Only that single file.
>
> The file has both checksums and datacow on it. I will do "chattr +C"
> on the parent dir and re-create the file to make sure all files are
> marked as "nodatacow".
>
> Should I also turn off checksums with the mount-flags if this
> filesystem only contain big VM-files? Or is it not needed if I put +C
> on the parent dir?

Please God don't turn off of checksums.  Checksums are tracked in 
metadata anyway, they won't show up in the data accounting.  Our csums 
are 8 bytes per block, so basic math says you are going to max out at 
604 megabytes for that big of a file.

Please people try to only take advice from people who know what they are 
talking about.  So unless it's from somebody who has commits in 
btrfs/btrfs-progs take their feedback with a grain of salt.  Thanks,

Josef

