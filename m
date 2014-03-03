Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:3347 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755241AbaCCWSs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 17:18:48 -0500
Message-ID: <5314FFB9.9090306@fb.com>
Date: Mon, 3 Mar 2014 17:18:33 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: 3.14.0-rc3 btrfs scrub is preventing my laptop from going to
 sleep
References: <20140227190656.GA28338@merlins.org> <5314B446.6000400@fb.com> <5314B737.10609@fb.com> <20140303220558.GA16865@merlins.org>
In-Reply-To: <20140303220558.GA16865@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/03/2014 05:05 PM, Marc MERLIN wrote:
> On Mon, Mar 03, 2014 at 12:09:11PM -0500, Josef Bacik wrote:
>> Ok I lied I just went ahead and did it, please let me know if
>> this fixes it
> 
> This looked promising, but I still have the problem.
> 
> PM: Syncing filesystems ... done. PM: Preparing system for mem
> sleep Freezing user space processes ... Freezing of tasks failed
> after 20.005 seconds (1 tasks refusing to freeze, wq_busy=0): btrfs
> D ffff8800b9c60840     0 12711      1 0x00000084 ffff8803bc475958
> 0000000000000086 ffff8803bc475fd8 ffff8800b9c60310 00000000000141c0
> ffff8800b9c60310 ffff8803cd8d8000 ffff8800ca31d300 0000000000000000
> ffff8803b2306b40 ffff8803cd8d8220 ffff8803bc475968 Call Trace: 
> [<ffffffff8160c331>] schedule+0x73/0x75 [<ffffffff8126eb7e>]
> scrub_pages+0x27e/0x426 [<ffffffff810850c9>] ?
> finish_wait+0x65/0x65 [<ffffffff81271964>]
> scrub_stripe+0xada/0xc9e [<ffffffff81271bfe>]
> scrub_chunk.isra.9+0xd6/0x10d [<ffffffff81271ea8>]
> scrub_enumerate_chunks+0x273/0x49f [<ffffffff81085000>] ?
> prepare_to_wait_event+0xba/0xf2 [<ffffffff81272674>]
> btrfs_scrub_dev+0x254/0x3cb [<ffffffff8116dde3>] ?
> __mnt_want_write+0x62/0x78 [<ffffffff81255e9a>]
> btrfs_ioctl+0x1114/0x24b1 [<ffffffff8114069b>] ?
> ____cache_alloc+0x1c/0x29b [<ffffffff81140a09>] ?
> kmem_cache_alloc_node+0xef/0x179 [<ffffffff8160ea0b>] ?
> _raw_spin_unlock+0x17/0x2a [<ffffffff81163b16>]
> do_vfs_ioctl+0x3d2/0x41d [<ffffffff8116bd38>] ? __fget+0x6f/0x79 
> [<ffffffff81163bb8>] SyS_ioctl+0x57/0x82 [<ffffffff816154ad>]
> system_call_fastpath+0x1a/0x1f
> 
> I compared with the previous kernel, and it's mostly the same
> trace: [<ffffffff8160c311>] schedule+0x73/0x75 [<ffffffff8126eb66>]
> scrub_pages+0x27e/0x42b [<ffffffff810850c9>] ?
> finish_wait+0x65/0x65 [<ffffffff81271951>]
> scrub_stripe+0xada/0xca3 [<ffffffff81271bf0>]
> scrub_chunk.isra.9+0xd6/0x10d [<ffffffff81271e9a>]
> scrub_enumerate_chunks+0x273/0x49f [<ffffffff81085000>] ?
> prepare_to_wait_event+0xba/0xf2 [<ffffffff81272666>]
> btrfs_scrub_dev+0x254/0x3cb [<ffffffff8116dde3>] ?
> __mnt_want_write+0x62/0x78 [<ffffffff81255e82>]
> btrfs_ioctl+0x1114/0x24b1 [<ffffffff81015efa>] ?
> paravirt_sched_clock+0x9/0xd [<ffffffff810164a0>] ?
> sched_clock+0x9/0xb [<ffffffff811408bd>] ?
> ____cache_alloc+0x23e/0x29b [<ffffffff81140a09>] ?
> kmem_cache_alloc_node+0xef/0x179 [<ffffffff8160e9eb>] ?
> _raw_spin_unlock+0x17/0x2a [<ffffffff81163b16>]
> do_vfs_ioctl+0x3d2/0x41d [<ffffffff8116bd38>] ? __fget+0x6f/0x79 
> [<ffffffff81163bb8>] SyS_ioctl+0x57/0x82 [<ffffffff816154ad>]
> system_call_fastpath+0x1a/0x1f
> 
> I'm not too sure why the scrub didn't stop as per your patch.
> 
> Maybe it will work if we cancel the scrub as opposed to pausing it,
> but of course it's not ideal. Is that the next step?
> 

Sigh I thought the PM stuff called freeze_fs() but I think that was
just tuxonice.  I don't have a quick fix at the moment, I really will
have to wait on this until after qgroups.  Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFP+vAAoJEANb+wAKly3BT7gP/j5B5sCPycpGT282vtMjk/BU
lLxIbPY3TOJgA8r5ZVBYt7glsQDk+Vct9CMqxuwT9cbgIN6wVxoj0fl40jAWsJpL
5ZNMO/dkRUZzwYiprSf9SwCZRNgjD+jTXMIl+/h9Daxajj8HJIWGovxomGpZbYKJ
/Qv9GRm2emhcIstLM0t1+Fv/OSk28TiRg5VtOM60AqposqGbXEK/IfuQxBMrgT2y
IUu0z+aJ2v4ykx7CHHYOLYYegfSwe/E3MZTG1KifswEi3iidiCrIstDJ2rHw7T3/
xjli3LWHb2KFRZ+gbi0lAo6cQVvGENG/jYxA8mAqTfDno7z6Xg46gCM8vT6LAfJF
x4B9AUntMPJPDxiscRMkOZZE0CJhVtqdJ8QLQHguRoloS0jMXmXaF/ibH2BDB24h
aacTxRQXH6XJOBRqHOp9drGMy1F69eKl+YaA3OWDVn2En83aXY+zY1acuYAGwA5H
Da4WYMoiP2DiCsn4gneFmikW/oh9HkxMA81hikdrrkoOhrIIvF9iKVv/mOJcvokA
568ha9QWwS1Wwif1JLs9NUj8Ff2vrTm5g5SJKIV365nWUME63wVx6sWnRmKDButx
qhJ5EMRlK3aVk+SjHDGLlzswpMZQFbC8v++J/vl6AoZuCWNetK7IyGlWcD1vCEVS
eCVIHioVA1/7Kt693Gnx
=q454
-----END PGP SIGNATURE-----
