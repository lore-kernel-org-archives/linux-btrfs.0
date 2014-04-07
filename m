Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:31676 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbaDGIcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Apr 2014 04:32:10 -0400
Received: from mfilter26-d.gandi.net (mfilter26-d.gandi.net [217.70.178.154])
	by relay6-d.mail.gandi.net (Postfix) with ESMTP id 03794FB8CB
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Apr 2014 10:32:08 +0200 (CEST)
Received: from relay6-d.mail.gandi.net ([217.70.183.198])
	by mfilter26-d.gandi.net (mfilter26-d.gandi.net [10.0.15.180]) (amavisd-new, port 10024)
	with ESMTP id zXhCR-IwJmtt for <linux-btrfs@vger.kernel.org>;
	Mon,  7 Apr 2014 10:32:06 +0200 (CEST)
Received: from zafu.localnet (dhcp230.cr2i.univ-montp2.fr [162.38.105.230])
	(Authenticated sender: michel@bouissou.net)
	by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 36F56FB8CD
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Apr 2014 10:32:05 +0200 (CEST)
From: =?ISO-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
To: linux-btrfs@vger.kernel.org
Subject: Scrub bug on kernel 2.13
Date: Mon, 07 Apr 2014 10:32:04 +0200
Message-ID: <17911062.Cl4v2ZqDNL@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

Machine got rebooted while scrub was in process, and now it looks like a scrub 
zombie...

How do I restore this to a normal non-zombie state ?

root@zafu:~# btrfs scrub status /
scrub status for 13c87f57-3a85-4daf-a4bf-ba777407c169
        scrub started at Mon Apr  7 09:49:48 2014, running for 693 seconds
        total bytes scrubbed: 34.06GiB with 0 errors

root@zafu:~# btrfs scrub cancel /
ERROR: scrub cancel failed on /: not running

root@zafu:~# btrfs scrub start /
ERROR: scrub is already running.
To cancel use 'btrfs scrub cancel /'.
To see the status use 'btrfs scrub status [-d] /'.

root@zafu:~# btrfs scrub status /
scrub status for 13c87f57-3a85-4daf-a4bf-ba777407c169
        scrub started at Mon Apr  7 09:49:48 2014, running for 693 seconds
        total bytes scrubbed: 34.06GiB with 0 errors

-- 
Swâmi Petaramesh <swami@petaramesh.org> http://petaramesh.org PGP 9076E32E

