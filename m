Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from qmta10.emeryville.ca.mail.comcast.net ([76.96.30.17]:51951 "EHLO
	qmta10.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753629Ab3ACTfS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 3 Jan 2013 14:35:18 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: Option LABEL
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <DF59971D-A5F2-4664-A4A7-2095CD8382DB@colorremedies.com>
Date: Thu, 3 Jan 2013 12:35:15 -0700
Message-Id: <1CC7957D-2FAD-4E8D-9850-6A06458FF1ED@colorremedies.com>
References: <CO8iwyguCXB@helmut.hullen.de> <DF59971D-A5F2-4664-A4A7-2095CD8382DB@colorremedies.com>
To: "linux-btrfs@vger.kernel.org list" <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 3, 2013, at 12:18 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> On Jan 3, 2013, at 12:08 PM, Hullen@t-online.de (Helmut Hullen) wrote:
> 
>> Labelling via "btrfs filesystem label <device> <label>" works well.
> 
> It's a bug. I'm able to reproduce it as well. The command language itself indicates its the fs that's to be labeled. "device" in this case maps a /dev/X device to a fs UUID. It always should apply to the file system. If you want to name your partitions, use GPT.

OK on a Fedora 18 test system with kernel 3.6.11-3 and btrfs-progs-0.20.rc1.20121017git91d9eec-1.fc18.x86_64 I'm getting different results. File system is never mounted for this test.

# mkfs.btrfs -L test /dev/sd[bc]
# btrfs fi label /dev/sdb
test
# btrfs fi label /dev/sdc
test
# btrfs fi label /dev/sdc test2
# btrfs fi label /dev/sdc
test2
# btrfs fi label /dev/sdb
test2

So 'btrfs fi label' relabeling with an unmounted system changes the file system label metadata on all member devices, according to btrfs fi label. Now when I use file:

# file -s /dev/sdb
/dev/sdb: BTRFS Filesystem (label "test2", sectorsize 4096, nodesize 4096, leafsize 4096)
# file -s /dev/sdc
/dev/sdc: BTRFS Filesystem (label "test2", sectorsize 4096, nodesize 4096, leafsize 4096)

Again it correctly reports the label, even though I had only changed the label on sdc (which actually is improper language, I changed the label on the file system implied by device sdc which also extends to device sdb). And then for blkid:

# blkid
/dev/sdb: LABEL="test2" UUID="3d5390d0-a41b-4f70-a4e5-b47295d3c717" UUID_SUB="a5bbaa83-6d6f-45dc-9804-9442350c3bc9" TYPE="btrfs" 
/dev/sdc: LABEL="test2" UUID="3d5390d0-a41b-4f70-a4e5-b47295d3c717" UUID_SUB="01e0bc77-cfdf-4bd7-bfd3-05e14affa66a" TYPE="btrfs" 

So again, the correct filesystem label is returned, for this unmounted file system.


Chris Murphy


