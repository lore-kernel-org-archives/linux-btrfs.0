Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:3891 "EHLO
	srv2.trombetti.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab2KJVSp (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 10 Nov 2012 16:18:45 -0500
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: SASL)
	by srv2.trombetti.net (Postfix) with ESMTPSA id 632E25421A
	for <linux-btrfs@vger.kernel.org>; Sat, 10 Nov 2012 16:18:44 -0500 (EST)
Message-ID: <509EC4B2.6090706@shiftmail.org>
Date: Sat, 10 Nov 2012 22:18:42 +0100
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: High-sensitivity fs checker (not repairer) for btrfs
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello all
I would like to know if there exists a tool to check the btrfs 
filesystem very thoroughly.
It's ok if it needs the FS unmounted to operate. Also mounted is OK.
It does not need repair capability
It needs very good checking capability: it has to return Good / Bad 
status with the "Bad" meaning that there is at least ONE inconsistency. 
Good means that it is really really 100% consistent.

Does something like this exists?

We need to detect as much ahead of time as possible if the btrfs 
filesystem has become even just a little bit inconsistent

Thank you
