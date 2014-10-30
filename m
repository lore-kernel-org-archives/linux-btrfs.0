Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 10.mo1.mail-out.ovh.net ([178.32.96.102]:57285 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161277AbaJ3W1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 18:27:15 -0400
Received: from mail98.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo1.mail-out.ovh.net (Postfix) with SMTP id 07892FFB70C
	for <linux-btrfs@vger.kernel.org>; Thu, 30 Oct 2014 17:28:48 +0100 (CET)
From: Cyril Scetbon <cyril.scetbon@free.fr>
Content-Type: text/plain; charset=us-ascii
Subject: Quota question
Message-Id: <A97945F6-2C7C-40A1-A291-D1498DA2FE8C@free.fr>
Date: Thu, 30 Oct 2014 17:28:41 +0100
To: linux-btrfs@vger.kernel.org
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

At https://btrfs.wiki.kernel.org/index.php/Quota_support it's said that "Using btrfs subvolume delete will break qgroup unshared space usage". Does it mean that if the qgroup associated with the subvolume is attached to another qgroup, this other qgroup won't be able to correctly apply its quota ? If yes, is there a workaround for that ?

Thanks
-- 
Cyril SCETBON

