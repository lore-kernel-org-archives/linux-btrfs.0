Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolouchovi.com.246.248.89.in-addr.arpa ([89.248.246.154]:40888
	"EHLO mail.kolouch.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbbJXRl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Oct 2015 13:41:59 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.kolouch.org (Postfix) with ESMTP id 1B31929D2E0E
	for <linux-btrfs@vger.kernel.org>; Sat, 24 Oct 2015 19:36:24 +0200 (CEST)
Received: from mail.kolouch.org ([127.0.0.1])
	by localhost (localhost [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cI09qhokh48T for <linux-btrfs@vger.kernel.org>;
	Sat, 24 Oct 2015 19:36:19 +0200 (CEST)
Received: from nbnb1 (unknown [89.248.244.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kolouch.org (Postfix) with ESMTPSA id E263729D2E09
	for <linux-btrfs@vger.kernel.org>; Sat, 24 Oct 2015 19:36:18 +0200 (CEST)
Date: Sat, 24 Oct 2015 19:36:17 +0200
From: kolcon@kolcon.net
To: linux-btrfs@vger.kernel.org
Subject: btrfs double send
Message-ID: <20151024173617.GA26012@nbnb1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I would like to do backups based on btrfs send/receive.

So I though I would do a transfer over portable HDD and then incremental
sends (using -p) over network.

Initial :

btrfs send "all" (primary HDD) →  btrfs receive (portable HDD) →  btrfs 
send/receive (final HDD)

Later :

btrfs send -p "all" new →  ssh newhost "btrfs receive … "

But I found out that does not work. It complains parent not found.

Am I doing something wrong, or is it intended behaviour?

Best regards,

Lubos
