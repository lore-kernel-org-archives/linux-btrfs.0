Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:59017 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866AbaKCQgF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Nov 2014 11:36:05 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XlKbr-0007HR-UJ
	for linux-btrfs@vger.kernel.org; Mon, 03 Nov 2014 17:36:03 +0100
Received: from hsi-kbw-149-172-191-171.hsi13.kabel-badenwuerttemberg.de ([149.172.191.171])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Nov 2014 17:36:03 +0100
Received: from mailinglists by hsi-kbw-149-172-191-171.hsi13.kabel-badenwuerttemberg.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 03 Nov 2014 17:36:03 +0100
To: linux-btrfs@vger.kernel.org
From: Florian Lindner <mailinglists@xgm.de>
Subject: Re: Can't mount: open_ctree failed!
Date: Mon, 03 Nov 2014 17:35:51 +0100
Message-ID: <m38at7$b0c$1@ger.gmane.org>
References: <m35i04$u5p$1@ger.gmane.org> <5456B0C8.8070402@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Robert White wrote:

> On 11/02/2014 07:18 AM, Florian Lindner wrote:
>> # btrfsck /dev/sdb1
>> # btrfsck --init-extent-tree /dev/sdb1
>> # btrfsck --init-csum-tree /dev/sdb1
> 
> Notably missing from all these commands is "--repair"...
> 
> I don't know that's your problem for sure, but it's where I would start...

Sorry, forgot to mention it. Of course I tried all command with --repair.

Florian

