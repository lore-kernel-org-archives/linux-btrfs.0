Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36386 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751034AbdHaOxS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 31 Aug 2017 10:53:18 -0400
From: Josef Bacik <jbacik@fb.com>
To: Marc MERLIN <marc@merlins.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Date: Thu, 31 Aug 2017 14:52:56 +0000
Message-ID: <D6E7AD8E-AF2B-4A17-9692-FDE17F31A8D2@fb.com>
References: <20170715004828.f4bom5wq34abe4lz@merlins.org>
 <20170711062155.hvlx5ud4zphpzjnp@merlins.org>
 <20170715012216.njq6az3y34qyomtb@merlins.org>
 <20170715231245.GA28281@merlins.org> <20170829031637.GA15290@merlins.org>
 <F952197E-3A13-410A-B299-F5C0791A99DF@fb.com>
 <20170829143955.GD15290@merlins.org>
 <EEF8B32C-179F-431A-880F-A27AD96B4BEF@fb.com>
 <20170830034001.rlwaqsitco65exqi@merlins.org>
In-Reply-To: <20170830034001.rlwaqsitco65exqi@merlins.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

Sorry I really thought I could accomplish this with BPF, but ref tracking is just too complicated to work properly with BPF.  I forward ported my ref verification patch to the latest kernel, you can find it in the btrfs-readdir branch of my btrfs-next tree here

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git

Just check that out, git checkout btrfs-readdir, build with CONFIG_BTRFS_FS_REF_VERIFY=y, and then mount the problematic fs with â€“o ref_verify and then grab the full output when it blows up and we should be able to work out what is happening from there.  Thanks,

Josef

On 8/29/17, 11:41 PM, "Marc MERLIN" <marc@merlins.org> wrote:

On Tue, Aug 29, 2017 at 06:22:38PM +0000, Josef Bacik wrote:
> How much metadata do you have on this fs?  I was going to hold everything in bpf hash trees, but Iâ€™m worried weâ€™ll hit collisions and then the tracing will be useless.  If itâ€™s too big Iâ€™ll have to dump everything to userspace and let python take care of keeping everything in memory, so if you have a lot of metadata hopefully you have lots of memory too ;).  Thanks,

gargamel:~# btrfs fi df /mnt/btrfs_pool1
Data, single: total=10.60TiB, used=10.54TiB
System, DUP: total=32.00MiB, used=1.19MiB
Metadata, DUP: total=58.00GiB, used=12.69GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: https://urldefense.proofpoint.com/v2/url?u=http-3A__marc.merlins.org_&d=DwIDaQ&c=5VD0RTtNlTh3ycd41b3MUw&r=sDzg6MvHymKOUgI8SFIm4Q&m=q-HXS1ddbqcYmJLp6pXcQoJL7qBXplbRAFRQ4eGSQYw&s=yyIlFUXCBjQ2xLoWBYzasW3BtBiLrITfkKLWvnhqgOs&e=                          | PGP 1024R/763BE901


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
