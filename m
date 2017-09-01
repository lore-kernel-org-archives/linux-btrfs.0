Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.20]:50856 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750876AbdIAFPz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 1 Sep 2017 01:15:55 -0400
Subject: Re: joining to contribute
To: Anthony Riley <anth1y@gmail.com>, linux-btrfs@vger.kernel.org
References: <CANM+MUmnKX0UJk-SN9t=aBz7Xfq6Dfn73AhZBO5EBpdSh+HVtw@mail.gmail.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <07225e42-1ffe-0289-27a1-811cd6e579a5@gmx.com>
Date: Fri, 1 Sep 2017 13:15:45 +0800
MIME-Version: 1.0
In-Reply-To: <CANM+MUmnKX0UJk-SN9t=aBz7Xfq6Dfn73AhZBO5EBpdSh+HVtw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月01日 11:36, Anthony Riley wrote:
> Hey folks,
> 
> I thought I would finally take a swing at things I've wanted to be an
> kernel/fs dev fora few years now. My current $job is as an
> Infrastructure Engineer. I'm currently teaching myself C and have
> background in shell scripting & python. I love doing deep dives and
> learning about linux internals.  I've read the btrfs.wiki and can't
> really decide which project to choose to start.
> 
> Also should I go through this https://kernelnewbies.org/FirstKernelPatch first?
> Or should i start with something in Userspace?

Well, personally I strongly recommended to start with btrfs on-disk 
format first, and then btrfs-progs/test cases, and kernel contribution 
as final objective.

BTW, if you want to start with btrfs on-disk format, print-tree.c from 
btrfs-progs is a good start point and btrfs wiki has relatively well 
documented entry for it.
https://btrfs.wiki.kernel.org/index.php/Btrfs_design
https://btrfs.wiki.kernel.org/index.php/Btree_Items

Thanks,
Qu
> 
> Thanks in advance,
> Really eager to get going.
> 
> Anthony
> 
