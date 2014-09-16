Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:43321 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbaIPHqS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Sep 2014 03:46:18 -0400
Message-ID: <5417EAC2.80607@codethink.co.uk>
Date: Tue, 16 Sep 2014 08:46:10 +0100
From: Paul Sherwood <paul.sherwood@codethink.co.uk>
MIME-Version: 1.0
To: Anand Jain <Anand.Jain@oracle.com>,
        Sam Thursfield <sam.thursfield@codethink.co.uk>
CC: Chris Mason <clm@fb.com>, linux-btrfs@vger.kernel.org,
        baserock-dev@baserock.org
Subject: Re: Unable to mount multiple subvolumes of a single disk
References: <5417022A.5000101@codethink.co.uk> <54170BCA.7070900@fb.com> <54170F35.4040103@oracle.com> <54171E51.2020709@codethink.co.uk> <54172018.1050300@oracle.com> <5417250B.9030105@oracle.com>
In-Reply-To: <5417250B.9030105@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Anand
On 15/09/2014 18:42, Anand Jain wrote:
>>> The patch fixes the issue, although it took a little tweaking to get it
>>> to apply cleanly.

I'm working with Sam. This is what I applied, and it works:

diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 340a92d..2c87b72 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -533,7 +533,7 @@ static noinline int device_list_add(const char *path,
                 * the btrfs dev scan cli, after FS has been mounted.
                 */
                if (fs_devices->opened) {
-                       return -EBUSY;
+                        goto out;
                } else {
                        /*
                         * That is if the FS is _not_ mounted and if you
@@ -570,6 +570,8 @@ static noinline int device_list_add(const char *path,
                fs_devices->latest_devid = devid;
                fs_devices->latest_trans = found_transid;
        }
+
+out:
        *fs_devices_ret = fs_devices;

        return ret;

> Sam,
> 
>   In the above context, Can you pls share the btrfs fi show output ?

btrfs fi show gives:

Label: 'src2'  uuid: c2fcd4f8-cc40-4fab-b13b-0d1268afb497
	Total devices 1 FS bytes used 77.93GB
	devid    1 size 100.00GB used 100.00GB path /dev/sdb

Label: 'baserock'  uuid: 129aff8f-65d9-4a19-9e2e-c3826bf5087d
	Total devices 1 FS bytes used 3.11GB
	devid    1 size 4.00GB used 4.00GB path /dev/sda

Btrfs v0.20-rc1-334-g304f215

br
Paul

