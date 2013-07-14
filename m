Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:34288 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752990Ab3GNS73 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 14 Jul 2013 14:59:29 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.5 \(1508\))
Subject: Re: super block crcs don't match, older mkfs detected
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <D14E3C70-436A-4177-AF88-9B097CF8DA96@colorremedies.com>
Date: Sun, 14 Jul 2013 12:59:27 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <FD7B76F7-970C-4080-995B-56E301CF2236@colorremedies.com>
References: <E2D2617A-BB44-4850-A071-407237F84ACA@colorremedies.com> <20130714181346.GE29644@carfax.org.uk> <D14E3C70-436A-4177-AF88-9B097CF8DA96@colorremedies.com>
To: Hugo Mills <hugo@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jul 14, 2013, at 12:19 PM, Chris Murphy <lists@colorremedies.com> wrote:

> 
> On Jul 14, 2013, at 12:13 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> 
>> On Sun, Jul 14, 2013 at 12:11:04PM -0600, Chris Murphy wrote:
>>> On Fedora 19 with all updates, when I mkfs.btrfs and then mount the volume, I'm getting this in dmesg:
>>> 
>>> [  280.534868] Btrfs loaded
>>> [  280.581799] device fsid 94ed05cb-89a9-4d6b-a1e2-5312687b59f5 devid 1 transid 4 /dev/mapper/vg1-brick1
>>> [  280.590140] btrfs: super block crcs don't match, older mkfs detected
>>> [  280.597746] btrfs: disk space caching is enabled
>>> [  280.661204] SELinux: initialized (dev dm-4, type btrfs), uses xattr
>>> 
>>> btrfs-progs-0.20.rc1.20130308git704a08c-1.fc19.x86_64
>>> kernel-3.10.0-1.fc20.x86_64
>>> 
>>> Is this expected? Benign?
>> 
>> Yes, I believe it's harmless and will go away after the first
>> mount.
> 
> Weird. I don't get this message on a regular partition, e.g. mkfs.btrfs /dev/sda7, mount /dev/sda7 /data. I only get it so far when formatting an lvm thinp LV.

No error with a regular partition or LV, or a small thinp LV. But with larger thinp LVs, I get some out of memory related errors, but the mkfs still completes, then I'm getting the CRC mismatch error on mount. So this may be a real CRC mismatch problem, due to concurrent out of memory problems. So I'm going to chock this up, for now, to other thinp related issues.


Chris Murphy