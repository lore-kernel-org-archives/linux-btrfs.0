Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:15099 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbaDAOuk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Apr 2014 10:50:40 -0400
Received: from fuchsia.localnet (p5DE8DE40.dip0.t-ipconnect.de [93.232.222.64])
	by smtp.strato.de (RZmta 32.31 DYNA|AUTH)
	with ESMTPSA id u0580dq31EocFf0
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client did not present a certificate)
	for <linux-btrfs@vger.kernel.org>;
	Tue, 1 Apr 2014 16:50:38 +0200 (CEST)
From: Michael Schuerig <michael.lists@schuerig.de>
To: linux-btrfs@vger.kernel.org
Subject: SELinux on btrfs
Date: Tue, 01 Apr 2014 16:50:38 +0200
Message-ID: <5090808.sXhgbrHacY@fuchsia>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


I'm currently considering to use SELinux on an existing system with 
btrfs filesystems. This would be my first with SELinux and I wouldn't 
expect everything to go smoothly. I'm already aware that SELinux's 
automatic labelling of files is not aware of subvolumes[*]. I already 
have quite a few read-only snapshots that I don't want to forfeit, 
however, I'm not at all sure how SELinux would interact with them.

Are there any other considerations I ought to be aware of?

Michael


[*] https://wiki.debian.org/SELinux/Setup#btrfs
-- 
Michael Schuerig
mailto:michael@schuerig.de
http://www.schuerig.de/michael/

