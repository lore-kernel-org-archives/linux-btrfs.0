Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47188 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494AbaCCQ4w (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 11:56:52 -0500
Message-ID: <5314B446.6000400@fb.com>
Date: Mon, 3 Mar 2014 11:56:38 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: 3.14.0-rc3 btrfs scrub is preventing my laptop from going to
 sleep
References: <20140227190656.GA28338@merlins.org>
In-Reply-To: <20140227190656.GA28338@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/27/2014 02:06 PM, Marc MERLIN wrote:
> This does not happen consistently, but sometimes:
> 
> PM: Preparing system for mem sleep Freezing user space processes
> ... (...) Freezing of tasks failed after 20.002 seconds (1 tasks
> refusing to freeze, wq_busy=0): btrfs           D ffff88017639c800
> 0 12239  12224 0x00000084 ffff880165ec1960 0000000000000086
> ffff880165ec1fd8 ffff88017639c2d0 00000000000141c0 ffff88017639c2d0
> ffff88007b874000 ffff8804062fa480 0000000000000000 ffff880175837ec0
> ffff88007b874220 ffff880165ec1970 Call Trace: [<ffffffff8160b0d9>]
> schedule+0x73/0x75 [<ffffffff8126e94c>] scrub_pages+0x27e/0x426 
> [<ffffffff81085062>] ? finish_wait+0x65/0x65 [<ffffffff81271732>]
> scrub_stripe+0xada/0xc9e [<ffffffff812719cc>]
> scrub_chunk.isra.9+0xd6/0x10d [<ffffffff81271c77>]
> scrub_enumerate_chunks+0x274/0x418 [<ffffffff81085000>] ?
> finish_wait+0x3/0x65 [<ffffffff812723bb>]
> btrfs_scrub_dev+0x254/0x3cb [<ffffffff8116ddab>] ?
> __mnt_want_write+0x62/0x78 [<ffffffff81255c68>]
> btrfs_ioctl+0x1114/0x24b1 [<ffffffff81140698>] ?
> ____cache_alloc+0x1c/0x29b [<ffffffff81140a06>] ?
> kmem_cache_alloc_node+0xef/0x179 [<ffffffff8160d7b3>] ?
> _raw_spin_unlock+0x17/0x2a [<ffffffff81163ade>]
> do_vfs_ioctl+0x3d2/0x41d [<ffffffff8116bd00>] ? __fget+0x6f/0x79 
> [<ffffffff81163b80>] SyS_ioctl+0x57/0x82 [<ffffffff8161426d>]
> system_call_fastpath+0x1a/0x1f
> 
> 
> And then I end up with a hot laptop and a mostly dead battery in my
> backpack.
> 
> As far as I know, this was not happening with 3.13, unless I'm
> doing something differently without knowing.
> 
> My laptop went to sleep just fine while I was typing this Email, so
> I'm guessing it's only btrfs scrub that causes the problem with
> sleep.
> 

We probably need to put something in ->fs_freeze() to pause scrubbing
(and this probably applies to snapshot deletion too) so you can
hibernate.  Should be easy enough to do, I'll look into it after
quotas unless somebody beats me to it.  Thanks,

Josef

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFLRGAAoJEANb+wAKly3BrpsP/j2icV1uDOPGzjCwI/J3HRR2
aYy40Q1WRklCaEH0q42UOPZ7EH3I07qOv7XX0OKrgQ/UBex+EvP824HQxNsejGQI
h6Pt5oH2j9xhGG3FCUzxjuN9uEbo89fIiJpJb+3YUoHkBW2w9hWBQTyQEe5DvVHA
O6SZ77Zq6q0+NEjzBaxVYR9paUo0Sqs6Vyn407wsM7FYlvyJ8RWzLMgEdkSpa2v5
kXQNrv72oRAcajxwhp5LvLCHb6KyJ4DjAFt47N+ezkEJHda8AAOTYs1DJ0E/Bl0s
sNL6+Uh+jZj8q61FZrO+qVmlFwd9YtnGGFQrLBPIfI8/ocp7OHLYNgc93/NAuvCk
bvBtRcI4kshSa0E+qE5qxuBPC8lRjWNyK5eoPA+KqXycR6aPzqqr58ghx5RC4v71
SsU6EF9oKyZ35FFLeuE7H1sEO9jlVrk1OlbIlUDCmxNK+QY3jPmvgfvU1qJyOQZw
4NRGCg7JYn7aEWrnYWG5qEXal9wTeXgof5p0+clGmsZMcgm3D6xfbPg755e10cq1
ZPJiVqHANBEvWyK2596fJkZNmVYyE8nvuCW62HMpsJjZJZ+p2Huje8DtbGf5uN1T
D5hy0NeJ0GFggxloA4CKpcBREq+uV+e584xtgsnxU4ulqWyqOiIIsVlQhE9+RXBV
7sSCnY4l24zoA2n+JOiY
=DKfb
-----END PGP SIGNATURE-----
