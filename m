Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:47409 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbcEGJmf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 May 2016 05:42:35 -0400
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout3.freenet.de with esmtpa (ID g6094199@freenet.de) (port 25) (Exim 4.85 #1)
	id 1ayykr-0000bY-1H
	for linux-btrfs@vger.kernel.org; Sat, 07 May 2016 11:42:33 +0200
Received: from localhost ([::1]:43687 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID g6094199@freenet.de) (Exim 4.85 #1)
	id 1ayykq-0002K1-TW
	for linux-btrfs@vger.kernel.org; Sat, 07 May 2016 11:42:33 +0200
Received: from mx2.freenet.de ([195.4.92.12]:50400)
	by mjail0.freenet.de with esmtpa (ID g6094199@freenet.de) (Exim 4.85 #1)
	id 1ayyi5-0006D8-Ef
	for linux-btrfs@vger.kernel.org; Sat, 07 May 2016 11:39:41 +0200
Received: from web5.emo.freenet-rz.de ([194.97.107.218]:38801)
	by mx2.freenet.de with esmtpa (ID g6094199@freenet.de) (port 587) (Exim 4.85 #1)
	id 1ayyi5-0007NF-CX
	for linux-btrfs@vger.kernel.org; Sat, 07 May 2016 11:39:41 +0200
Received: from localhost ([127.0.0.1] helo=emo.freenet.de)
	by web5.emo.freenet-rz.de with esmtpa (Exim 4.84_2 2 (Panther_1))
	id 1ayyi4-0004A9-KD
	for <linux-btrfs@vger.kernel.org>; Sat, 07 May 2016 11:39:40 +0200
Date: Sat, 07 May 2016 11:39:40 +0200
From: g6094199@freenet.de
Subject: btrfs-tools: missing device delete/remove cancel option on disk failure
To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Message-Id: <1ba2f46d66b988069f861df8526e4cba@email.freenet.de>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

He guys,

i'm running in an rare error which isnt covered by an implemented usecase atm.i have a 4 hdd raid5 array. i like to replace the 4 disks with bigger ones to gain more usable space the NAS has only 4 drive bays so i need to use an usb bay.
since the replace code was unreliable at least before 4.4 afaik, the plan was to add anew disk to the array, balance and remove one of the small disks this should be safe.

BUT what if, if the new drive i'm adding is failing while doing the remove/delete operation? 
this is what i'm running into right now. a brand new disk which has an upcounting raw error rate. 
but there is no option to cancel an delete/remove operation. 
atm it isnt a problem for me. i hope to complete the operation successfully and replace the failingdrive afterwards.

please consider to add an option to exit/cancel an delete/remove operation like in replace/scrub/...

thx!

sash




---
Mail & Cloud Made in Germany mit 3 GB Speicher! https://email.freenet.de/mail/Uebersicht?epid=e9900000450

