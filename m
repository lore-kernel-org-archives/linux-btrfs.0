Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34476 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751660AbcFGBTN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jun 2016 21:19:13 -0400
Message-Id: <1465262352.3622603.629909497.30BD010E@webmail.messagingengine.com>
From: Kai Hendry <hendry@iki.fi>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
Subject: Re: btrfs device delete /dev/sdc1 /mnt/raid1 user experience
Date: Tue, 07 Jun 2016 09:19:12 +0800
In-Reply-To: <7fea30e3-a39a-e72d-4776-7a7bfe4f7ef5@gmail.com>
References: <1465191858.3381218.628872649.1C5D6003@webmail.messagingengine.com>
 <7fea30e3-a39a-e72d-4776-7a7bfe4f7ef5@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 6 Jun 2016, at 10:16 PM, Austin S. Hemmelgarn wrote:
> Based on the fact that you appear to want to carry a disk to copy data 
> more quickly than over then internet, then what you've already done plus 
> this is the correct way to do it.

The trouble is the way I ended up doing it:
1) Replacing it with a bigger disk
2) Deleting the disk
3) btrfs send /mnt/raid1/snapshot | btrfs receive /mnt/onetb/

This took almost **an entire day** over USB3 spinning disks  !

My expectation was that I could quickly remove a mirrored disk, replace
that disk and hand carry the disk I removed. btrfs shouldn't remove data
from the disk I removed.

Kind regards,
