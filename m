Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:63130 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751336AbaLSVr0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 16:47:26 -0500
Message-ID: <54949CEA.7020905@fb.com>
Date: Fri, 19 Dec 2014 16:47:22 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0: kernel BUG at fs/btrfs/relocation.c:242!
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com> <542EE83D.8050701@fb.com> <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com> <438e043f73392614d1453892b7fe225c@admin.virtall.com> <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com>
In-Reply-To: <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/12/2014 09:37 AM, Tomasz Chmielewski wrote:
> FYI, still seeing this with 3.18 (scrub passes fine on this filesystem).
>
> # time btrfs balance start /mnt/lxc2
> Segmentation fault
>

Ok now I remember why I haven't fix this yet, the images you gave me 
restore but then they don't mount because the extent tree is corrupted 
for some reason.  Could you re-image this fs and send it to me and I 
promise to spend all of my time on the problem until its fixed.  Thanks,

Josef

