Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postler.lichtfels.com ([78.46.92.195]:57342 "EHLO
	postler.lichtfels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbaIVUvN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Sep 2014 16:51:13 -0400
Received: from localhost (localhost [127.0.0.1])
	by postler.lichtfels.com (Postfix) with ESMTP id 4C1B8123D2
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 22:51:11 +0200 (CEST)
Received: from postler.lichtfels.com ([127.0.0.1])
 by localhost (postler.lichtfels.com [127.0.0.1]) (amavisd-maia, port 10024)
 with LMTP id 30632-08 for <linux-btrfs@vger.kernel.org>;
 Mon, 22 Sep 2014 22:51:09 +0200 (CEST)
Received: from hiro.oops.intern (mail.oops.co.at [213.129.238.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by postler.lichtfels.com (Postfix) with ESMTPSA id 55A16123C9
	for <linux-btrfs@vger.kernel.org>; Mon, 22 Sep 2014 22:51:09 +0200 (CEST)
Message-ID: <54208BBC.1000700@xunil.at>
Date: Mon, 22 Sep 2014 22:51:08 +0200
From: "Stefan G. Weichinger" <lists@xunil.at>
Reply-To: lists@xunil.at
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: general thoughts and questions + general and RAID5/6 stability?
References: <8D1A2626CC69D79-11FC-A2C3@webmail-va141.sysops.aol.com> <pan$5a87e$97e2e260$54942ad0$cefe56f1@cox.net>
In-Reply-To: <pan$5a87e$97e2e260$54942ad0$cefe56f1@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 20.09.2014 um 11:32 schrieb Duncan:

> What I do as part of my regular backup regime, is every few kernel cycles 
> I wipe the (first level) backup and do a fresh mkfs.btrfs, activating new 
> optional features as I believe appropriate.  Then I boot to the new 
> backup and run a bit to test it, then wipe the normal working copy and do 
> a fresh mkfs.btrfs on it, again with the new optional features enabled 
> that I want.

Is re-creating btrfs-filesystems *recommended* in any way?

Does that actually make a difference in the fs-structure?

So far I assumed it was enough to keep the kernel up2date, use current
(stable) btrfs-progs and run some scrub every week or so (not to mention
backups .. if it ain't backed up, it was/isn't important).

Stefan




