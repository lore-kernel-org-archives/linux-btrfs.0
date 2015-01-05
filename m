Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:45222 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbbAELhF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 06:37:05 -0500
Date: Mon, 5 Jan 2015 12:31:47 +0100
From: Lennart Poettering <lennart@poettering.net>
To: Harald Hoyer <harald@redhat.com>
Cc: linux-btrfs@vger.kernel.org, Kay Sievers <kay@vrfy.org>
Subject: Re: Extend BTRFS_IOC_DEVICES_READY for degraded RAID
Message-ID: <20150105113147.GA18350@gardel-login>
References: <54AA5D86.1000503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54AA5D86.1000503@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 05.01.15 10:46, Harald Hoyer (harald@redhat.com) wrote:

> We have BTRFS_IOC_DEVICES_READY to report, if all devices are present, so that
> a udev rule can report ID_BTRFS_READY and SYSTEMD_READY.
> 
> I think we need a third state here for a degraded RAID, which can be mounted,
> but should only after a certain timeout/kernel command line params.
> 
> We also have to rethink how to handle the udev DB update for the change of the
> state. incomplete -> degraded -> complete

I am not convinced that automatically booting degraded arrays would be
a good idea. Instead, requiring one manual step before booting a
degraded array sounds OK to me.

Lennart

-- 
Lennart Poettering, Red Hat
