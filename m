Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51425 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750885AbaLOUHr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 15:07:47 -0500
Message-ID: <548F3F8E.408@fb.com>
Date: Mon, 15 Dec 2014 15:07:42 -0500
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
> real    322m32.153s
> user    0m0.000s
> sys     16m0.930s
>
>

Sorry Tomasz, you are now at the top of the list.  I assume the images 
you sent me before are still good for reproducing this?  Thanks,

Josef

