Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:34265 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753080AbaGaPfq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 31 Jul 2014 11:35:46 -0400
Received: from mail-in-05-z2.arcor-online.net (mail-in-05-z2.arcor-online.net [151.189.8.17])
	by mx.arcor.de (Postfix) with ESMTP id 70E21D8142
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Jul 2014 17:35:44 +0200 (CEST)
Received: from mail-in-15.arcor-online.net (mail-in-15.arcor-online.net [151.189.21.55])
	by mail-in-05-z2.arcor-online.net (Postfix) with ESMTP id 6BA3313203D
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Jul 2014 17:35:44 +0200 (CEST)
Received: from webmail09.arcor-online.net (webmail09.arcor-online.net [151.189.8.45])
	by mail-in-15.arcor-online.net (Postfix) with ESMTP id 618371AB525
	for <linux-btrfs@vger.kernel.org>; Thu, 31 Jul 2014 17:35:44 +0200 (CEST)
Date: Thu, 31 Jul 2014 17:35:44 +0200 (CEST)
From: dptrash@arcor.de
To: linux-btrfs@vger.kernel.org
Message-ID: <1028108337.2120293.1406820944449.JavaMail.ngmail@webmail09.arcor-online.net>
References: <1731942750.1162128.1406757898913.JavaMail.ngmail@webmail06.arcor-online.net>
Subject: btrfs on bcache
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Concerning http://thread.gmane.org/gmane.comp.file-systems.btrfs/31018, does this "bug" still exists?

Kernel 3.14
B: 2x HDD 1 TB
C: 1x SSD 256 GB

# make-bcache -B /dev/sda /dev/sdb -C /dev/sdc --cache_replacement_policy=lru
# mkfs.btrfs -d raid1 -m raid1 -L "BTRFS_RAID" /dev/bcache0 /dev/bcache1

I still have no "incomplete page write" messages in "dmesg | grep btrfs" and the checksums of some manually reviewed files are okay.

Who has more experiences about this?

Thanks,

- dp
