Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.187]:58090 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751272AbbIOVeI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 17:34:08 -0400
Received: from durkon.lan ([178.201.238.189]) by mrelayeu.kundenserver.de
 (mreue004) with ESMTPSA (Nemesis) id 0MR97T-1ZBNdR1eaV-00Ud1A for
 <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 23:34:06 +0200
Received: from xykon.lan (xykon.lan [192.168.2.42])
	by durkon.lan (Postfix) with ESMTPSA id 669D28323
	for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 23:34:04 +0200 (CEST)
From: Gert Menke <gert@menke.ac>
Subject: BTRFS as image store for KVM?
To: linux-btrfs@vger.kernel.org
Message-ID: <55F88ECC.1040604@menke.ac>
Date: Tue, 15 Sep 2015 23:34:04 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi everybody,

first off, I'm not 100% sure if this is the right place to ask, so if 
it's not, I apologize and I'd appreciate a pointer in the right direction.

I want to build a virtualization server to replace my current home 
server. I'm thinking about a Debian system with libvirt/KVM. The system 
will have one or two SSDs and five harddisks with some kind of software 
RAID5 for storage. I'd like to have a filesystem with data checksums, so 
BTRFS seems like the right way to go. However, I read that BTRFS does 
not perform well as storage for KVM disk images.
(See here: http://www.linux-kvm.org/page/Tuning_KVM )

Is this still true?

I would appreciate any comments and/or tips you might have on this topic.

Is anyone using BTRFS as an image store? Are there any special settings 
I should be aware of to make it work well?

Thanks,
Gert
