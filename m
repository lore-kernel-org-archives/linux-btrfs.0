Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60279 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752752AbbJUTlJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 21 Oct 2015 15:41:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1ZozFk-0001yk-LN
	for linux-btrfs@vger.kernel.org; Wed, 21 Oct 2015 21:40:52 +0200
Received: from chello213047196183.tirol.surfer.at ([213.47.196.183])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 21:40:52 +0200
Received: from wertstoffe by chello213047196183.tirol.surfer.at with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 21 Oct 2015 21:40:52 +0200
To: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Jakob_Sch=c3=bcrz?= <wertstoffe@nurfuerspam.de>
Subject: btrfs-balance causes system-freeze on full disk
Date: Wed, 21 Oct 2015 21:38:52 +0200
Message-ID: <c76lfc-jfl.ln1@aldebaran.xundeenergie.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there!

Is it possible, what i've recognized now. My system (debian) runs on
btrfs, and i have a lot of snapshots on my hard-disk.
Since some days my system freezes totally. I recognized, it always
happens during btrfs-balance.

So i deleted some of the old snapshots and tried another balance-run.
Nothing happened... No system-freeze.

System-freeze means: No Keyboard-action. The Mouse is frozen, the screen
is frozen, no magic-sysreq, no ssh-login.

Can btrfs cause such a freeze??

greez

jakob
-- 
http://xundeenergie.at
http://verkehrsloesungen.wordpress.com/
http://cogitationum.wordpress.com/

