Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60749 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750795AbbEXJqR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 24 May 2015 05:46:17 -0400
Received: from merkaba.localnet (ppp-88-217-111-160.dynamic.mnet-online.de [88.217.111.160])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 2B7D211E
	for <linux-btrfs@vger.kernel.org>; Sun, 24 May 2015 11:46:16 +0200 (CEST)
From: Martin Steigerwald <martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: [BUG] [4.1-rc4] hung tasks on resume
Date: Sun, 24 May 2015 11:46:15 +0200
Message-ID: <38718451.QrrZiIAI7Z@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I had another BTRFS hang¹. It may be related to the kworker at 100% on write 
issue that still happened with 4.0 kernels² as / device was 100% allocated 
and it seems that bug doesn´t happen if there is still device space left to 
be allocated for chunks.

But this time it was on resume from hibernation. All I could get was a 
backtrace on the console.


IMHO this still is not production ready, despite any other sayings.


[1] [Bug 98821] New: btrfs hung tasks on resume from hibernation
https://bugzilla.kernel.org/show_bug.cgi?id=98821

[2] [Bug 90401] New: btrfs kworker thread uses up 100% of a Sandybridge core 
for minutes on random write into big file
https://bugzilla.kernel.org/show_bug.cgi?id=90401

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
