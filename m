Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.mailbox.org ([80.241.60.215]:46431 "EHLO mx2.mailbox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751419AbcFJKyW (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 10 Jun 2016 06:54:22 -0400
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx2.mailbox.org (Postfix) with ESMTPS id DD55D434C5
	for <linux-btrfs@vger.kernel.org>; Fri, 10 Jun 2016 12:54:18 +0200 (CEST)
Received: from smtp1.mailbox.org ([80.241.60.240])
	by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
	with ESMTP id CAYVOiGHn973 for <linux-btrfs@vger.kernel.org>;
	Fri, 10 Jun 2016 12:54:17 +0200 (CEST)
Date: Fri, 10 Jun 2016 12:54:17 +0200 (CEST)
From: Lenz Grimmer <lenz@grimmer.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <1026941351.8013.1465556057388@office.mailbox.org>
Subject: Managing storage (incl. Btrfs) on Linux with openATTIC
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

if you're using Btrfs on Linux for file serving purposes, i'd like to invite you to take a look at our open source storage management project "openATTIC":

  http://openattic.org/

We provide a web UI and RESTful API to create CIFS/NFS shares on top of Btrfs and other file systems, including monitoring and snapshots. Other file systems like ext4, XFS or ZFS are supported, too. We also support sharing block volumes via iSCSI and Fibre Channel via LIO and are currently working on adding Ceph Management and Monitoring support as well.

openATTIC 2.0 is currently in development and we're looking for more testers and feedback. Packages for the Debian/Ubuntu, RHEL/CentOS and SUSE are available via apt/yum repos.

For the time being, we don't yet support all the nifty Btrfs features (e.g. RAID levels), but you can already use openATTIC to manage (e.g. creating and snapshotting) and monitor Btrfs file systems via the WebUI. We plan to further extend the Btrfs functionality incrementally with each release. Some use cases we have in mind are documented here: https://wiki.openattic.org/display/OP/openATTIC+Storage+Management+Use+Cases

So if you're looking for a free (GPLv2) storage management tool that supports your favorite file system, we'd be glad if you give openATTIC a try!

Thanks and sorry for the noise,

Lenz
-- 
 Lenz Grimmer <lenz@grimmer.com> - http://www.lenzg.net/
