Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33330 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbcCPQTR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Mar 2016 12:19:17 -0400
Date: Wed, 16 Mar 2016 17:18:52 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v2 RESEND] btrfs: maintain consistency in logging to help
 debugging
Message-ID: <20160316161852.GO21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1457583778-4042-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1457583778-4042-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 10, 2016 at 12:22:58PM +0800, Anand Jain wrote:
> Optional Label may or may not be set, or it might be set at some time
> later. However while debugging to search through the kernel logs the
> scripts would need the logs to be consistent, so logs search key words
> shouldn't depend on the optional variables, instead fsid is better.

I think the label is a useful information, as it's set by the user. So
if I'm looking to the log, I'll recognize the labels, not the device or
fsid.

It would be better to show all of them, ie. label, fsid, device and
transid. The line will get longer, but I hope it's ok.

Proposed order of the fields:
- device PATH
- devid ID
- fsid UUID
- transid TID

> -		if (disk_super->label[0]) {
> -			printk(KERN_INFO "BTRFS: device label %s ", disk_super->label);
> -		} else {
> -			printk(KERN_INFO "BTRFS: device fsid %pU ", disk_super->fsid);
> -		}
> -
> -		printk(KERN_CONT "devid %llu transid %llu %s\n", devid, transid, path);
> +		printk(KERN_INFO "BTRFS: device fsid %pU devid %llu transid %llu %s\n",
> +						disk_super->fsid, devid, transid, path);
