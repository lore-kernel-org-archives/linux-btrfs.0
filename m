Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx11.system-hoster.com ([193.143.122.58]:10314 "EHLO
	mx3.system-hoster.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753366Ab2EXGN7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 May 2012 02:13:59 -0400
From: =?iso-8859-1?Q?Bj=F6rn_W=FCst?= <Bjoern.Wuest@iteratec.de>
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Date: Thu, 24 May 2012 08:05:23 +0200
Subject: Preparing single-disk setup for future multi-disk usage
Message-ID: <5A83377DACA90F4896A338250D088E8F14B35F09@HMEXMBCLUS01.ci04.de>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Good morning,


I currently have a single-disk setup where I want to use btrfs filesystem. Yet, I expect to add additional disks to this system in the future. Those disks shall be visible to the OS like a single disk, i.e. using multi-disk feature in btrfs. While data shall be striped among those disks in the future, meta data shall be mirrored for better fault tolerance (loss of some data is acceptable, while loss of all data is not acceptable).

btrfs supports multi-disk setups and even adding additional devices at a later point of time. Thus, it is my preferred choice. However, I am puzzled how the mkfs.btrfs command must be parametrized to have RAID1 for meta data and RAID0 for data with just a single disk / partition. Could I simply do mkfs.btrfs -m raid1 -d raid0 /dev/sdaX (where X is the partition number) ?

Unfortunately, I do not have a disk to test it right now. The disk I am planning to use is with the post service still :) . Searching the Web could not reveal a similar scenario. All multi-disk examples assume that you already have multiple disks and not that you are going to have them.

Thank you for your replies to this email (bjoern.wuest@gmx.net, I am not subscribed to the mailing lists, thus please do a 'reply all').


Mit freundlichen Grüßen / Kind regards
  Bjoern Wuest

