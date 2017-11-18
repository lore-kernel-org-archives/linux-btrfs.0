Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr50070.outbound.protection.outlook.com ([40.107.5.70]:53760
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1759487AbdKRM3v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 18 Nov 2017 07:29:51 -0500
Subject: Re: 4.14 balance: kernel BUG at
 /home/kernel/COD/linux/fs/btrfs/ctree.c:1856!
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
To: Roman Mamedov <rm@romanrm.net>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <e01cb2f95b44b7648855a4fe5070fd10@wpkg.org>
 <5000f429-8b4b-b4ea-5e38-89f7c91af6f3@mendix.com>
 <20171118144037.0fa8ad4b@natsu>
 <2cbd136b-4fa7-fcee-7472-0941efa97047@mendix.com>
Message-ID: <909afcf3-3eff-52eb-c679-4e300dd61bda@mendix.com>
Date: Sat, 18 Nov 2017 13:29:45 +0100
MIME-Version: 1.0
In-Reply-To: <2cbd136b-4fa7-fcee-7472-0941efa97047@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/18/2017 12:48 PM, Hans van Kranenburg wrote:
> 
> So, who wants to help?
> 
> 1. Find a test system that you can crash.
> 2. Create a test filesystem with some data.
> 3. Run with 4.14? (makes the most sense I think)
> 4. Continuously feed the data to balance and send everything to /dev/null
> 5. Collect stack traces and borken filesystem images.

Ok, what I just did:

-# mkfs.btrfs --nodiscard /dev/xvdb
-# mount -o noatime /dev/xvdb /btrfs
-# cd btrfs/
-# btrfs sub create usr
-# rsync -av /usr/ usr/
-# btrfs sub snap -r usr/ usro

And then, both at the same time:

-# while true; do btrfs send usro/ > /dev/null; date; echo 3 >
/proc/sys/vm/drop_caches; done

and

-# while true; do btrfs balance start --full-balance /btrfs; done

After a few minutes we have the first error:


[ 1605.484627] BTRFS error (device xvdb): did not find backref in
send_root. inode=4260, offset=0, disk_byte=130793844736 found
extent=130793844736

Sat Nov 18 13:25:28 CET 2017
At subvol usro/
ERROR: send ioctl failed with -5: Input/output error

No big stack trace this time.

-- 
Hans van Kranenburg
