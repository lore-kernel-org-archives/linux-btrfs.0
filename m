Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:54407 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751496AbaJaF2a (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 01:28:30 -0400
Message-ID: <1414733232.5809.22.camel@localhost.localdomain>
Subject: Re: read block failed check_tree_block / Couldn't read chunk tree
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Anand Jain <Anand.Jain@oracle.com>
CC: Rene Thomas <re.thomas@gmx.de>, <linux-btrfs@vger.kernel.org>
Date: Fri, 31 Oct 2014 13:27:12 +0800
In-Reply-To: <545062CC.6020206@oracle.com>
References: <CAHOQfW0CF1CrHrZ_T_G49kXh6scKK59aYYZn48fi112RfHX=wg@mail.gmail.com>
	 <545062CC.6020206@oracle.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 2014-10-29 at 11:45 +0800, Anand Jain wrote:
> this is (most likely) due to patch below,
> ----------------
> commit 915902c5002485fb13d27c4b699a73fb66cc0f09
> 
>      btrfs-progs: fix device missing of btrfs fi show with seed devices
> ----------------
> 
>   Could you try to back out the patch from progs and give it a shot ?
>   and pls report what you see. Thanks.

Hi Anand,
-------------------------------------------------------------------
 # btrfs fi show
Label: 'mythstorage'  uuid: 9b454272-6800-4b3c-b196-9e180407a6cb
        Total devices 1 FS bytes used 2.36MiB
        devid    1 size 931.51GiB used 10.04GiB path /dev/sdd1

[errors from open_ctree]

Label: none  uuid: 8ef575d9-2465-479c-bf9c-067e2e417770
        Total devices 3 FS bytes used 3.02TiB
        devid    1 size 2.73TiB used 1.77TiB path /dev/sdb1
        devid    2 size 2.73TiB used 1.77TiB path /dev/sda1
        devid    3 size 2.73TiB used 1.77TiB path /dev/sdc1
Btrfs v3.17
------------------------------------------------------------------

The original output of btrfs fi show actually detect all devices in all
btrfs successfully. I think the patch mentioned above really missed some
case in which num of devices found match the num of all devices in one
btrfs. In such case, we should not bother trying to detect seed devices.

And for now, we did. Unfortunately, the btrfs is some what corrupted by
mkfs.ntfs, so @open_ctree call complains about corruption on the chunk
root like the following:

> Check tree block failed, want=5845480062976, have=0
> Check tree block failed, want=5845480062976, have=0
> Check tree block failed, want=5845480062976, have=65536
> Check tree block failed, want=5845480062976, have=0
> Check tree block failed, want=5845480062976, have=0
> read block failed check_tree_block
> Couldn't read chunk tree

I'll fix this case by avoiding @open_ctree call when all devices in
btrfs are detected.

But if not all devices are detected, then there are 3 possible cases:
1) seed devices present
2) disk unpluged
3) disk reformatted

For case 1), *for now* we need the @open_ctree to detect them(After
your former proposal implemented, things may be different).

For case 2) & 3), @open_ctree complains as above. To clean the not so
helpful and annoying complains, I think we could keep @open_ctree silent
when called by btrfs fi show by introduce a new flag OPEN_CTREE_SILENT.

Thanks
Gui

> 
> 
> On 10/25/14 00:43, Rene Thomas wrote:
> >   # btrfs --version
> > Btrfs v3.17
> >
> >   # btrfs fi show
> > Label: 'mythstorage'  uuid: 9b454272-6800-4b3c-b196-9e180407a6cb
> >          Total devices 1 FS bytes used 2.36MiB
> >          devid    1 size 931.51GiB used 10.04GiB path /dev/sdd1
> >
> >   Check tree block failed, want=5845480062976, have=0
> > Check tree block failed, want=5845480062976, have=0
> > Check tree block failed, want=5845480062976, have=65536
> > Check tree block failed, want=5845480062976, have=0
> > Check tree block failed, want=5845480062976, have=0
> > read block failed check_tree_block
> > Couldn't read chunk tree
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


