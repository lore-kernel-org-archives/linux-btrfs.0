Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7422 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486Ab2KHRGM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 8 Nov 2012 12:06:12 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id qA8H6CMT016983
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Thu, 8 Nov 2012 12:06:12 -0500
Message-ID: <509BE682.6010008@redhat.com>
Date: Thu, 08 Nov 2012 18:06:10 +0100
From: Ondrej Kozina <okozina@redhat.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: lczerner@redhat.com
Subject: question about btrfsck/mount behavior on corrupted fs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

I've been playing with btrfs resize recently and run into strange 
looking behavior to me. One of my simple test scenario was following:

- partition some block device (lets say sda sectors 2-2000 are sda1)
- try to create btrfs on top of it (just mkfs.btrfs /dev/sda1)
- fill the fs with data
- unmount the device
- let's simulate usual mistake here: downsize the partition with btrfs 
filesystem w/o proper btrfs resize command. In fact I moved the 
beginning of the sda2 partition into middle of former sda1. so now it 
looks like: 2-1000 sda1, 1001-2000 sda2.
- remount the fs

I was surprised both commands btrfsck and mount were successful w/o any 
error report even in syslog. Does it work as intended? Do you plan to 
support some sort of checks during mount/btrfsck? Possibly a new feature 
in btrfsck utility to warn the user something ugly happened to his fs? 
Is there any way to fix broken fs like this (supposing the cut off area 
didn't contain allocated blocks)?

Kind regards
Ondrej
