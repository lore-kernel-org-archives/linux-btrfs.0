Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17293 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab3AHHFr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Jan 2013 02:05:47 -0500
Message-ID: <50EBC512.4020106@oracle.com>
Date: Tue, 08 Jan 2013 15:04:50 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: replace simple_strtoull() with kstrtoull() in
 btrfs_ioctl_resize()
References: <50E8F545.5030706@oracle.com> <20130107160350.GI20089@twin.jikos.cz>
In-Reply-To: <20130107160350.GI20089@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/08/2013 12:03 AM, David Sterba wrote:
> On Sun, Jan 06, 2013 at 11:53:41AM +0800, Jeff Liu wrote:
>> -		devid = simple_strtoull(devstr, &end, 10);
>> +		ret = kstrtoull(devstr, 10, &devid);
>> +		if (ret) {
>> +			pr_err("btrfs: resizer unable to parse device %s\n",
>> +				devstr);
> 
> Code looks ok, I would prefer the message error text to say:
> 
> 			pr_err("btrfs: resize unable to parse device id %s\n",
> 				devstr);
> 
> but that's maybe just me :)
Thanks for the review, yours is better :)
The revised patch was shown as following:


simple_strtoull() is obsolete, use kstrtoull() instead.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Cc: David Sterba <dsterba@suse.cz>

---
 fs/btrfs/ioctl.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 8fcf9a5..d9045eb 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1331,11 +1331,16 @@ static noinline int btrfs_ioctl_resize(struct btrfs_root *root,
 	sizestr = vol_args->name;
 	devstr = strchr(sizestr, ':');
 	if (devstr) {
-		char *end;
 		sizestr = devstr + 1;
 		*devstr = '\0';
 		devstr = vol_args->name;
-		devid = simple_strtoull(devstr, &end, 10);
+		ret = kstrtoull(devstr, 10, &devid);
+		if (ret) {
+			pr_err("btrfs: resizer unable to parse device id %s\n",
+				devstr);
+			ret = -EINVAL;
+			goto out_free;
+		}
 		printk(KERN_INFO "btrfs: resizing devid %llu\n",
 		       (unsigned long long)devid);
 	}
-- 
1.7.9.5

