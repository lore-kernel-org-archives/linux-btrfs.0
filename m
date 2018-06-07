Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f194.google.com ([74.125.82.194]:45328 "EHLO
        mail-ot0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933108AbeFGSlV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jun 2018 14:41:21 -0400
Received: by mail-ot0-f194.google.com with SMTP id a5-v6so12699842otf.12
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jun 2018 11:41:21 -0700 (PDT)
MIME-Version: 1.0
From: james harvey <jamespharvey20@gmail.com>
Date: Thu, 7 Jun 2018 14:41:20 -0400
Message-ID: <CA+X5Wn6EP4nxGA7hE4HCUa9jWpk3XVVPdR0zb1v9Yd-y9kH5Ew@mail.gmail.com>
Subject: Re: [PATCH v3 (Only) 2/3] btrfs-progs: map-logical: Use btrfs_next_extent_item()
To: Su Yue <suy.fnst@cn.fujitsu.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>
In-Reply-To: <CA+X5Wn7U_8cdO-fDzgfKmKvBqavzamQUNz6sDX7pePSWd-pcjg@mail.gmail.com>

On Thu, Jun 7, 2018 at 4:50 AM, Su Yue <suy.fnst@cn.fujitsu.com> wrote:
> On 06/07/2018 03:20 PM, james harvey wrote:
>>
>> btrfs_next_extent_item() looks for BTRFS_EXTENT_ITEM_KEY and
>> BTRFS_METADATA_KEY,
>> which are the types we're looking for.
>>
>> Signed-off-by: James Harvey <jamespharvey20@gmail.com>
>
> Reviewed-by: Su Yue <suy.fnst@cn.fujitsu.com>

btrfs_next_extent_item() looks for BTRFS_EXTENT_ITEM_KEY and BTRFS_METADATA_KEY,
which are the types we're looking for.

(Previous versions missed last 0 argument to btrfs_next_extent_item().  Sorry, I
realize I need to take more time before sending, being more careful on
everything.)

Signed-off-by: James Harvey <jamespharvey20@gmail.com>
---
 btrfs-map-logical.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/btrfs-map-logical.c b/btrfs-map-logical.c
index 2451012b..8a41b037 100644
--- a/btrfs-map-logical.c
+++ b/btrfs-map-logical.c
@@ -83,7 +83,8 @@ again:
                        ret = btrfs_previous_extent_item(fs_info->extent_root,
                                                         path, 0);
                else
-                       ret = btrfs_next_item(fs_info->extent_root, path);
+                       ret = btrfs_next_extent_item(fs_info->extent_root,
+                                                    path, 0);
                if (ret)
                        goto out;
                goto again;
--
2.17.0
