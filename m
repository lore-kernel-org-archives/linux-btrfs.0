Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from crius.lksmith.net ([66.228.38.125]:47890 "EHLO
	crius.lksmith.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbbBEVaE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Feb 2015 16:30:04 -0500
Received: from RAWRDesktop (unknown [IPv6:2601:2:4b80:b9e:89ef:7e8:ad2b:fa1e])
	by crius.lksmith.net (Postfix) with ESMTPSA id 043DA1E004
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Feb 2015 21:30:02 +0000 (UTC)
From: "Lucas Smith" <vedalken@lksmith.net>
To: <linux-btrfs@vger.kernel.org>
Subject: BTRFS EFI Boot question
Date: Thu, 5 Feb 2015 15:30:06 -0600
Message-ID: <005001d0418a$e980a980$bc81fc80$@lksmith.net>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey folks!

Having a confusing question brought up to me by my Debian Testing installer
and am unsure what the implications are for it. I want to run btrfs in
RAID10 on 4x1TB WD RE3 drives. Apparently, my system is set up to boot using
EFI. Are there any reasons not to use EFI Booting in this circumstance?

