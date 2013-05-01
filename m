Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50387 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab3EAIhp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 1 May 2013 04:37:45 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UXSXo-0003cL-MK
	for linux-btrfs@vger.kernel.org; Wed, 01 May 2013 10:37:44 +0200
Received: from 212.71.117.90 ([212.71.117.90])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 May 2013 10:37:44 +0200
Received: from alexanders.mailinglists+nospam by 212.71.117.90 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 01 May 2013 10:37:44 +0200
To: linux-btrfs@vger.kernel.org
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Subject: Re: Best Practice - Partition, or not?
Date: Wed, 1 May 2013 08:37:30 +0000 (UTC)
Message-ID: <loom.20130501T103631-501@post.gmane.org>
References: <loom.20130501T094600-451@post.gmane.org> <5180CB66.9030803@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello dima

dima <dolenin <at> parallels.com> writes:

> (NB: grub will not boot from "/dev/sdb", selinux will)

Fair point :)
I don't plan to boot from the disk, though. It's a data disk, if you will.

But, yeah, for a "best practice", that's certainly something to keep in mind.

BR,
Alexander

