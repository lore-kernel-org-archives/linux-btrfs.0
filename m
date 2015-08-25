Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp121.iad3a.emailsrvr.com ([173.203.187.121]:32849 "EHLO
	smtp121.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752059AbbHYPWe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 11:22:34 -0400
Received: from smtp16.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp16.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 29A79180811
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 11:22:34 -0400 (EDT)
Received: from smtp16.relay.iad3a.emailsrvr.com (localhost.localdomain [127.0.0.1])
	by smtp16.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 25C10180A07
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 11:22:34 -0400 (EDT)
Received: from app61.wa-webapps.iad3a (relay-webapps.rsapps.net [172.27.255.140])
	by smtp16.relay.iad3a.emailsrvr.com (SMTP Server) with ESMTP id 1CA11180811
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 11:22:34 -0400 (EDT)
Received: from up4.tv (localhost.localdomain [127.0.0.1])
	by app61.wa-webapps.iad3a (Postfix) with ESMTP id 0A790180050
	for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 11:22:34 -0400 (EDT)
Date: Tue, 25 Aug 2015 11:22:34 -0400 (EDT)
Subject: Response to Bcachefs Claims
From: "Vincent Olivier" <vincent@up4.com>
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Message-ID: <1440516154.040713246@apps.rackspace.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I have been using Btrfs for almost a year now with a 16x4TB RAID10 and its 8x4TB RAID0 backup (using incremental snapshots diffs). I have always tried to stay at the latest stable kernel (currently 4.1.6). But I might be moving to Fedora 22 because Centos 7 has significant incompatibilities with the 4.1.x kernel series.

I have seen the news about Bcachefs aiming to be Btrfs-complete while being extX-stable.

What are the chances Bcachefs beats Btrfs at being the Linux kernel's next "official" file system ? I chose Btrfs over ZFS because it seemed like the only "next-gen" heir to ext4/xfs.

I have been having a few problems with Btrfs myself. I have only one that remains unresolved : I haven't found the best way to mount Btrfs at boot time. "LABEL=" won't work for known reasons (I don't understand however why a mount can't do its own "device scan" transparently). "UUID=" won't work for unknown reasons (haven't got a reply on this, maybe it's the same as "LABEL="). And I will use /dev/* in fstab for stability reasons. Right now I'm mounting the fs manually after a "device scan" and picking up the first device that shows up in the "fi show" run. I can "live" with that but I suppose that things like this contribute to the feeling that Btrfs is actually still experimental contrarily to claims that it is production-ready.

For my own sake and other's I would like to maintain (if nobody is already working on that nor needs any help) a centralized human-readable digest of known issues that would be featured prominently on top of the Btrfs wiki. I would merge the Gotchas page and the various known issues pages (including the various multi-device mount gotchas here and there).

Answers ? Comments ? Help ?

Thanks,

Vincent

