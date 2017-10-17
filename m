Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33204 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933345AbdJQQkH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 17 Oct 2017 12:40:07 -0400
Date: Tue, 17 Oct 2017 18:38:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] Btrfs-progs: do not add stale device into fs_devices
Message-ID: <20171017163820.GB3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171011002852.2926-1-bo.li.liu@oracle.com>
 <20171011175716.8885-1-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171011175716.8885-1-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 11, 2017 at 11:57:16AM -0600, Liu Bo wrote:
> If one of btrfs's devices was pulled out and we've replaced it with a
> new one, then they have the same uuid.
> 
> If that device gets reconnected, 'btrfs filesystem show' will show the
> stale one instead of the new one, but on kernel side btrfs has a fix
> to not include the stale one, this could confuse users as people may
> monitor btrfs by running that cli.
> 
> This does the similar thing to what kernel side has done.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>
> Reviewed-by: Anand Jain <anand.jain@oracle.com>

Applied with the following diff, thanks.

--- a/volumes.c
+++ b/volumes.c
@@ -141,11 +141,12 @@ static int device_list_add(const char *path,
                char *name;

                /*
-                * The existing device has newer generation, so this
-                * one could be a stale one, don't add it.
+                * The existing device has newer generation, so this one could
+                * be a stale one, don't add it.
                 */
                if (found_transid < device->generation) {
-                       warning("adding device %s gen %llu but found an existing device %s gen %llu\n",
+                       warning(
+       "adding device %s gen %llu but found an existing device %s gen %llu",
                                path, found_transid, device->name,
                                device->generation);
                        return -EEXIST;
