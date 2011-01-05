From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH V3 0/6] random bugfixes of the space management
Date: Wed, 5 Jan 2011 11:48:47 -0600
Message-ID: <AANLkTinCxCL3YenLvCLTYixtH2faCpNN4p8g2RNgQUy4@mail.gmail.com>
References: <4D2442CF.8060702@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <josef@redhat.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D2442CF.8060702@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

2011/1/5 Miao Xie <miaox@cn.fujitsu.com>:
> Hello, Chris
>
> I have a bunch of random fixes of the space management in
>
> git://repo.or.cz/linux-btrfs-devel.git space-manage
>
> They are the ENOSPC fixes, as well as fixes for df command.
> The first one and the last one fixed the wrong free space information=
 reported
> by df command. The second one fixed ENOSPC when there is tiny space i=
n the
> filesystem. And The third fixed wrong calculation of stripe size. And=
 the 4th
> and 5th patches fixed the chunk allocation problem when the block dev=
ices have
> no enough space to allocate a default-size chunk.
>
> Changelog V2 -> V3:
> - fix panic caused by freeing a invalid memory address.
>
> Changelog V1 -> V2:
> - fix compiler errors on x86_32 machines.
> - fix some bugs when allocating dup chunks.
> - break the chunk allocation when errors happen.
> - just allocate min_stripes stripes when the free space is not enough=
=2E
> - cleanup redundant code.
>
> If you want to merge this patchset to your "next" branch for testing,=
 you can merge it
> directly after dropping the top four patches of the "next" branch.
>
> Thanks
> Miao
> ---
> =A0fs/btrfs/ctree.h =A0 =A0 =A0 | =A0 =A02 +
> =A0fs/btrfs/extent-tree.c | =A0 71 +++++-
> =A0fs/btrfs/super.c =A0 =A0 =A0 | =A0147 +++++++++++-
> =A0fs/btrfs/volumes.c =A0 =A0 | =A0614 ++++++++++++++++++++++++++++++=
+++++-------------
> =A0fs/btrfs/volumes.h =A0 =A0 | =A0 27 ++
> =A05 files changed, 685 insertions(+), 176 deletions(-)
>

The problems I was encountering in the V2 version of this patch set
are fixed in V3.

Thanks for the updates.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
