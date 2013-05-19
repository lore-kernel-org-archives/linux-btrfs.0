Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:41030 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab3ESS7R (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 19 May 2013 14:59:17 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Ue8p7-0002Nt-E2
	for linux-btrfs@vger.kernel.org; Sun, 19 May 2013 20:59:13 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 May 2013 20:59:13 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 19 May 2013 20:59:13 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs (general) raid for other filesystems?
Date: Sun, 19 May 2013 19:59:03 +0100
Message-ID: <knb7di$8ee$1@ger.gmane.org>
References: <knb28t$p9p$1@ger.gmane.org> <CAFvQSYQObGsKCf3iPtErfFvdQv6vqwc_KNAm5wt763ChrZWtUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <CAFvQSYQObGsKCf3iPtErfFvdQv6vqwc_KNAm5wt763ChrZWtUA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/05/13 18:39, Clemens Eisserer wrote:
> Hi Martin,
> 
>> So, an interesting variation could be to have filesystem level raid
>> operating on ext4 or nilfs or whatever... Would that be a sensible idea?
> 
> Thats already supported by using LVM. What do you think you would gain
> from layering in top of btrfs?

md-raid and lvm-raid are raid at the block level.

btrfs-raid offers a greater variety and far greater flexibility of raid
options individually for filedata and metadata at the filesystem level.

raid at the filesystem level should also gain higher performance over
that of just blindly replicating blocks of binary data across devices at
the block level.


My thoughts are to take advantage of the btrfs-raid work being done but
for all filesystems. Hence, we can then have a very flexible raid
available for whatever filesystem might be best for any underlying device.

OK... So we make all of lvm, md-raid, and drbd all redundant!

Regards,
Martin

