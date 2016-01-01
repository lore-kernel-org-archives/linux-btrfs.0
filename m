Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.dwami.com ([178.79.162.101]:37442 "EHLO mail.dwami.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922AbcAAQP2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 1 Jan 2016 11:15:28 -0500
Received: from orione.localnet (183.Red-83-50-202.dynamicIP.rima-tde.net [83.50.202.183])
	by mail.dwami.com (Postfix) with ESMTPSA id 81C13133C4
	for <linux-btrfs@vger.kernel.org>; Fri,  1 Jan 2016 16:06:06 +0000 (WET)
From: =?ISO-8859-1?Q?berny=AE?= <berny@dwami.com>
To: linux-btrfs@vger.kernel.org
Subject: Btrfs send / receive freeze system - Addendum
Date: Fri, 01 Jan 2016 16:06:05 +0000
Message-ID: <3823710.C4JhcYPFa8@orione>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, I forgot to mention that this freeze is happening after I converted 
this backup drive to btrfs, before it was XFS. So sending to XFS drive didn't 
caused the freeze while sending with the same script to btrfs formatted drive 
freeze the system. Kernel and btrfs progs were the same.

Regards.
