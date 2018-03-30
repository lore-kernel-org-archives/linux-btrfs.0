Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:51615 "EHLO
        mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750744AbeC3Hmc (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 03:42:32 -0400
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
        by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 09FA8AC019B
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Mar 2018 16:42:26 +0900 (JST)
Subject: Re: [PATCH 5/5] libbtrfsutil: fix test assumptions about top-level
 subvolume
To: Omar Sandoval <osandov@osandov.com>, <linux-btrfs@vger.kernel.org>
CC: <kernel-team@fb.com>
References: <cover.1522309741.git.osandov@fb.com>
 <459ffd8130e337e16fc2205584ee27883e959442.1522309741.git.osandov@fb.com>
From: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Message-ID: <bf2cdb91-867b-856b-a87c-afd46f406e68@jp.fujitsu.com>
Date: Fri, 30 Mar 2018 16:39:12 +0900
MIME-Version: 1.0
In-Reply-To: <459ffd8130e337e16fc2205584ee27883e959442.1522309741.git.osandov@fb.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2018/03/29 16:53, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> Since "btrfs-progs: mkfs: add uuid and otime to ROOT_ITEM of, FS_TREE",
> the top-level subvolume has a non-zero UUID, ctime, and otime. Fix the
> subvolume_info() test to not check for zero.

Sorry, I didn't notice this.

I checked this works in devel branch:
Reviewed-by: Tomohiro Misono <misono.tomohiro@jp.fujitsu.com>

> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
>  libbtrfsutil/python/tests/test_subvolume.py | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/libbtrfsutil/python/tests/test_subvolume.py b/libbtrfsutil/python/tests/test_subvolume.py
> index a46d4a34..93396cba 100644
> --- a/libbtrfsutil/python/tests/test_subvolume.py
> +++ b/libbtrfsutil/python/tests/test_subvolume.py
> @@ -95,7 +95,8 @@ class TestSubvolume(BtrfsTestCase):
>                  self.assertEqual(info.parent_id, 0)
>                  self.assertEqual(info.dir_id, 0)
>                  self.assertEqual(info.flags, 0)
> -                self.assertEqual(info.uuid, bytes(16))
> +                self.assertIsInstance(info.uuid, bytes)
> +                self.assertEqual(len(info.uuid), 16)
>                  self.assertEqual(info.parent_uuid, bytes(16))
>                  self.assertEqual(info.received_uuid, bytes(16))
>                  self.assertNotEqual(info.generation, 0)
> @@ -103,8 +104,8 @@ class TestSubvolume(BtrfsTestCase):
>                  self.assertEqual(info.otransid, 0)
>                  self.assertEqual(info.stransid, 0)
>                  self.assertEqual(info.rtransid, 0)
> -                self.assertEqual(info.ctime, 0)
> -                self.assertEqual(info.otime, 0)
> +                self.assertIsInstance(info.ctime, float)
> +                self.assertIsInstance(info.otime, float)>                  self.assertEqual(info.stime, 0)
>                  self.assertEqual(info.rtime, 0)
>  
> @@ -117,6 +118,7 @@ class TestSubvolume(BtrfsTestCase):
>          self.assertEqual(info.dir_id, 256)
>          self.assertEqual(info.flags, 0)
>          self.assertIsInstance(info.uuid, bytes)
> +        self.assertEqual(len(info.uuid), 16)
>          self.assertEqual(info.parent_uuid, bytes(16))
>          self.assertEqual(info.received_uuid, bytes(16))
>          self.assertNotEqual(info.generation, 0)
> 

