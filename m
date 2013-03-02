Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:54024 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751836Ab3CBKIA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 2 Mar 2013 05:08:00 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1UBjMZ-0005lP-T8
	for linux-btrfs@vger.kernel.org; Sat, 02 Mar 2013 11:08:19 +0100
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Mar 2013 11:08:19 +0100
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 02 Mar 2013 11:08:19 +0100
To: linux-btrfs@vger.kernel.org
From: Gabriel de Perthuis <g2p.code@gmail.com>
Subject: Permanent uncancellable balance
Date: Sat, 2 Mar 2013 10:07:45 +0000 (UTC)
Message-ID: <kgsj1h$oo1$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,
I have a filesystem that has become unusable because of a balance I can't 
stop. It is very close to full, and the balance is preventing me from 
growing it.

It was started like this:
sudo btrfs filesystem balance start -v -musage=60 -dusage=60 /srv/backups

It has been stuck at 0% across reboots and kernel upgrades (currently on 
3.8.1), and cancelling it had no effect:

Balance on '/srv/backups' is running
0 out of about 5 chunks balanced (95 considered), 100% left

According to atop it is writing but not reading anything.
Unmounting never terminates, so does remounting ro, the only way to 
temporarilly kill it is to reboot. SIGKILL has no effect either. Is there 
*any* way I can get rid of it?

