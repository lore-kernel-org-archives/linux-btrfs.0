Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55936 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751386AbaCCRJX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Mar 2014 12:09:23 -0500
Message-ID: <5314B737.10609@fb.com>
Date: Mon, 3 Mar 2014 12:09:11 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, <linux-btrfs@vger.kernel.org>
Subject: Re: 3.14.0-rc3 btrfs scrub is preventing my laptop from going to
 sleep
References: <20140227190656.GA28338@merlins.org> <5314B446.6000400@fb.com>
In-Reply-To: <5314B446.6000400@fb.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/03/2014 11:56 AM, Josef Bacik wrote:
> On 02/27/2014 02:06 PM, Marc MERLIN wrote:
>> This does not happen consistently, but sometimes:
> 
>> PM: Preparing system for mem sleep Freezing user space processes 
>> ... (...) Freezing of tasks failed after 20.002 seconds (1 tasks 
>> refusing to freeze, wq_busy=0): btrfs           D
>> ffff88017639c800 0 12239  12224 0x00000084 ffff880165ec1960
>> 0000000000000086 ffff880165ec1fd8 ffff88017639c2d0
>> 00000000000141c0 ffff88017639c2d0 ffff88007b874000
>> ffff8804062fa480 0000000000000000 ffff880175837ec0 
>> ffff88007b874220 ffff880165ec1970 Call Trace:
>> [<ffffffff8160b0d9>] schedule+0x73/0x75 [<ffffffff8126e94c>]
>> scrub_pages+0x27e/0x426 [<ffffffff81085062>] ?
>> finish_wait+0x65/0x65 [<ffffffff81271732>] 
>> scrub_stripe+0xada/0xc9e [<ffffffff812719cc>] 
>> scrub_chunk.isra.9+0xd6/0x10d [<ffffffff81271c77>] 
>> scrub_enumerate_chunks+0x274/0x418 [<ffffffff81085000>] ? 
>> finish_wait+0x3/0x65 [<ffffffff812723bb>] 
>> btrfs_scrub_dev+0x254/0x3cb [<ffffffff8116ddab>] ? 
>> __mnt_want_write+0x62/0x78 [<ffffffff81255c68>] 
>> btrfs_ioctl+0x1114/0x24b1 [<ffffffff81140698>] ? 
>> ____cache_alloc+0x1c/0x29b [<ffffffff81140a06>] ? 
>> kmem_cache_alloc_node+0xef/0x179 [<ffffffff8160d7b3>] ? 
>> _raw_spin_unlock+0x17/0x2a [<ffffffff81163ade>] 
>> do_vfs_ioctl+0x3d2/0x41d [<ffffffff8116bd00>] ? __fget+0x6f/0x79
>>  [<ffffffff81163b80>] SyS_ioctl+0x57/0x82 [<ffffffff8161426d>] 
>> system_call_fastpath+0x1a/0x1f
> 
> 
>> And then I end up with a hot laptop and a mostly dead battery in
>> my backpack.
> 
>> As far as I know, this was not happening with 3.13, unless I'm 
>> doing something differently without knowing.
> 
>> My laptop went to sleep just fine while I was typing this Email,
>> so I'm guessing it's only btrfs scrub that causes the problem
>> with sleep.
> 
> 
> We probably need to put something in ->fs_freeze() to pause
> scrubbing (and this probably applies to snapshot deletion too) so
> you can hibernate.  Should be easy enough to do, I'll look into it
> after quotas unless somebody beats me to it.  Thanks,
> 

Ok I lied I just went ahead and did it, please let me know if this
fixes it


- From 8ab47dd51e446fb2aa5dfc432c8c5b6ddd083371 Mon Sep 17 00:00:00 2001
From: Josef Bacik <jbacik@fb.com>
Date: Mon, 3 Mar 2014 12:07:11 -0500
Subject: [PATCH] Btrfs: pause scrubing when we freeze the fs

Need to make sure we don't keep scrubbing when we freeze the fs so
pause it
until we are unfrozen.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
- ---
 fs/btrfs/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index dc0a315..dc9ba85 100644
- --- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -1764,6 +1764,8 @@ static int btrfs_freeze(struct super_block *sb)
 	struct btrfs_trans_handle *trans;
 	struct btrfs_root *root = btrfs_sb(sb)->tree_root;

+	btrfs_scrub_pause(root);
+
 	trans = btrfs_attach_transaction_barrier(root);
 	if (IS_ERR(trans)) {
 		/* no transaction, don't bother */
@@ -1776,6 +1778,9 @@ static int btrfs_freeze(struct super_block *sb)

 static int btrfs_unfreeze(struct super_block *sb)
 {
+	struct btrfs_root *root = btrfs_sb(sb)->tree_root;
+
+	btrfs_scrub_continue(root);
 	return 0;
 }

- -- 
1.8.3.1

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTFLc3AAoJEANb+wAKly3BW4EQAKasDW7tHabddmS5x3f2Vf2x
rySPlP+cTszqcLTeTpeFB4rUolGOwOgZMlDLCK/q0/561uebzNTMp3khdwBCO1GA
hiavMilmdnJx1uZ6PR0xW4sCI+/GsMu/gPymAgOU21wsqb7L3a2+IC9TcqX+UMML
JwMn5QvqyBQ/ii9DmwHLsk+buqP0+o0wbVB//ltQKH98qn9b+AbIQEpfDT5F7xh6
5J/XEHPDFE1xJfqC7b2yTGTCyTUzUVCPzfolDGkOyZiQb4Lp/Ihn1Wh7hcW1J65z
rvouCFFgaoeBkcJJDH8Dm+9qq1pqKWIw24i0GBZ+0222nncGp+qDxgydxWJ640p0
LDILxFlov5kfqqpwc6KmcLCMXU0F2wnKF6dKY31eF3zPgJs/OV2N1wg2i1ojKCr+
e4fL7dB/f/2pLE3+bQFeNVxEH1JxNkj/bK8s6V/AaIyVMODAakhMPJi/9xYQk7tl
I37vr+AcMqCknvId1rZ9lDHJFJDtJCbA1PFPRdzf9OH2+RazN4vXl9xyjcoXdWZz
oQz5DfGEN+fliPjDgC09DVgzFjjyXWUv49O73eEm0iIMIVHTbUovwVBcebVafr1z
uugG0phhaA/gf11Q9UPwz3EHzlG+NGTmooE/Z4C5+I02z7KLDGTzGPByn7aspQOJ
Sq1mfu6wwCjjA/UVK73V
=kq6N
-----END PGP SIGNATURE-----
