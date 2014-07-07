Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19765 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaGGJV4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Jul 2014 05:21:56 -0400
Message-ID: <53BA66B0.9010706@oracle.com>
Date: Mon, 07 Jul 2014 17:21:52 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: miaox@cn.fujitsu.com
CC: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] btrfs: fix null pointer dereference in clone_fs_devices
 when name is null
References: <1404119568-4097-1-git-send-email-Anand.Jain@oracle.com> <53B135B2.5060405@cn.fujitsu.com> <53B17D0E.2050302@oracle.com> <53B370A7.6050108@cn.fujitsu.com> <53B68E42.1050109@oracle.com> <53B68EFC.2050104@oracle.com> <53BA0E77.6040804@cn.fujitsu.com>
In-Reply-To: <53BA0E77.6040804@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> It's a pity that the patch has been merged into the upstream kernel.
> Let's correct our miss before the next merge.

  What I found were new-bugs, those are not related to this patch.

> BTW, I sent some patches to fix the problems about seed device(including
> the updated patch of this one), could you try them and confirm that they
> can fix the problems you said above or not?
>
> [PATCH V2 7/9] btrfs: fix null pointer dereference in clone_fs_devices when name is null
> [PATCH 8/9] Btrfs: fix unzeroed members in fs_devices when creating a fs from seed fs
> [PATCH 9/9] Btrfs: fix writing data into the seed filesystem
>
> This first one is the updated patch of this one.

  With 8,9/9 it fixes the new-bugs as well. Thanks.

Anand
