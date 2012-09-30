Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35141 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751794Ab2I3XFc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 19:05:32 -0400
Date: Mon, 1 Oct 2012 01:05:25 +0200
From: David Sterba <dave@jikos.cz>
To: Robin Dong <robin.k.dong@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Robin Dong <sanbai@taobao.com>
Subject: Re: [PATCH v2 2/2] btrfs-progs: limit the min value of total_bytes
Message-ID: <20120930230525.GM14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348801360-1851-1-git-send-email-robin.k.dong@gmail.com>
 <1348801360-1851-2-git-send-email-robin.k.dong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348801360-1851-2-git-send-email-robin.k.dong@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 28, 2012 at 11:02:40AM +0800, Robin Dong wrote:
> From: Robin Dong <sanbai@taobao.com>
> 
> Using mkfs.btrfs like:
> 
>         mkfs.btrfs -b 1048576 /dev/sda
> 
> will report error:
> 
> 	mkfs.btrfs: volumes.c:796: btrfs_alloc_chunk: Assertion `!(ret)' failed.
> 	Aborted
> 
> because the length of dev_extent is 4MB.
> 
> But if we use mkfs.btrfs with 8MB total bytes, the newly mounted btrfs filesystem
> would not contain even one empty file. So 12MB will be good min-value for block_count.

I'm not able to create a single file even on a 12MB filesystem
(with -d single -m single --mixed), so any limit that would let the mkfs
finish normally should be fine. For the single/single case it's 5MB but
for the dup/dup it's 156MB. It's due to the known bug in the blockgroup
creation with multiple devices (applies on dup as well here) that leads
to:

# btrfs fi df .
System, DUP: total=8.00MB, used=4.00KB
System: total=4.00MB, used=0.00
Data+Metadata, DUP: total=64.00MB, used=24.00KB
Data+Metadata: total=8.00MB, used=0.00

8*2 + 4 + 64*2 + 8 = 156

so, 12M is too small to avoid the mkfs crash.

david
