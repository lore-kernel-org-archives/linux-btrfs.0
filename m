Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:42801 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752128AbaATImn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Jan 2014 03:42:43 -0500
Message-ID: <52DCE13D.9000303@cn.fujitsu.com>
Date: Mon, 20 Jan 2014 16:41:33 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>
CC: Shilong Wang <wangshilong1991@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: WARNING at fs/btrfs/backref.c:936 find_parent_nodes+0x378/0x5d2
References: <20140119140913.501c73e8@virtall.com> <CAP9B-Qn1PChub2fbwL6Mv6mDt_h3jjYs8r+h28Z3=hOHzdwB=A@mail.gmail.com> <20140119224654.4e600232@virtall.com>
In-Reply-To: <20140119224654.4e600232@virtall.com>
Content-Type: multipart/mixed;
 boundary="------------070604020409080308020606"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070604020409080308020606
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed

Hello Tomasz,

On 01/20/2014 05:46 AM, Tomasz Chmielewski wrote:
> No balance was running. The usual rsync and btrfs snapshots; I'm unable
> to say when exactly it happened (i.e. if it was during rsync or snapshot
> adding/removal).
>
> As of defragment - I didn't run it manually, but I have autodefrag
> option enabled:
Would you please try attached patch and see if problem happen again.:-)

Thanks,
Wang
>
> /dev/sdc1 on /mnt/lxc2 type btrfs
> (rw,noatime,compress-force=zlib,space_cache,autodefrag)
>
>


--------------070604020409080308020606
Content-Transfer-Encoding: 7bit
Content-Type: text/x-patch;
 name="0001-Btrfs-release-path-after-adding-missing-keys.patch"
Content-Disposition: attachment;
 filename*0="0001-Btrfs-release-path-after-adding-missing-keys.patch"

>From a97bab00f5351182962655901b8fb045ae7cf5ac Mon Sep 17 00:00:00 2001
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Date: Mon, 20 Jan 2014 15:17:45 +0800
Subject: [PATCH] Btrfs: release path after adding missing keys

Signed-off-by: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
---
 fs/btrfs/backref.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index d059cc8..b0ce27a 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -931,13 +931,13 @@ again:
 				goto out;
 		}
 	}
-	btrfs_release_path(path);
 
 	list_splice_init(&prefs_delayed, &prefs);
 
 	ret = __add_missing_keys(fs_info, &prefs);
 	if (ret)
 		goto out;
+	btrfs_release_path(path);
 
 	__merge_refs(&prefs, 1);
 
-- 
1.8.3.1


--------------070604020409080308020606--
