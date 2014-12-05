Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:35188 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaLEFlD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Dec 2014 00:41:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XwldV-0005tH-G5
	for linux-btrfs@vger.kernel.org; Fri, 05 Dec 2014 06:41:01 +0100
Received: from 179.181.69.10 ([179.181.69.10])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Dec 2014 06:41:01 +0100
Received: from bcdonadio by 179.181.69.10 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 05 Dec 2014 06:41:01 +0100
To: linux-btrfs@vger.kernel.org
From: Bernardo Donadio <bcdonadio@gmail.com>
Subject: Re: Another BTRFS kernel Oops
Date: Fri, 05 Dec 2014 03:40:47 -0200
Message-ID: <m5rggv$d2u$1@ger.gmane.org>
References: <4432682.FqYBntj3yh@vajra>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
In-Reply-To: <4432682.FqYBntj3yh@vajra>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04-12-2014 05:54, Swâmi Petaramesh wrote:
 > Hi there,
 >
 > BTFS is oopsing on me again ;-)
 >
 > # uname -r
 > 3.17.4-300.fc21.x86_64
 >
 >
 > Déc. 04 08:51:28 vajra kernel: ------------[ cut here ]------------
 > déc. 04 08:51:28 vajra kernel: WARNING: CPU: 2 PID: 758 at 
fs/btrfs/delayed-
 > inode.c:1410 btrfs_assert_delayed_root_empty+0x39/0x40 [btrfs]()

I have the exactly same issue. No apparent reason.

Already posted here three days ago, but no answer so far. Also I just
filled a report on Fedora Bugtracker, but the issue is probably upstream.

https://bugzilla.redhat.com/show_bug.cgi?id=1170905

I'm on 3.17.3-200-fc20.x86_64.

--
Bernardo Donadio

