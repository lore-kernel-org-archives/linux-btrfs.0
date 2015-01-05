Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbbAEJqx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Jan 2015 04:46:53 -0500
Message-ID: <54AA5D86.1000503@redhat.com>
Date: Mon, 05 Jan 2015 10:46:46 +0100
From: Harald Hoyer <harald@redhat.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>
Subject: Extend BTRFS_IOC_DEVICES_READY for degraded RAID
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We have BTRFS_IOC_DEVICES_READY to report, if all devices are present, so that
a udev rule can report ID_BTRFS_READY and SYSTEMD_READY.

I think we need a third state here for a degraded RAID, which can be mounted,
but should only after a certain timeout/kernel command line params.

We also have to rethink how to handle the udev DB update for the change of the
state. incomplete -> degraded -> complete
