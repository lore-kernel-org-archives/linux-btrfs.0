Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vm136.rz.uni-osnabrueck.de ([131.173.16.11]:40308 "EHLO
	smtp-auth.serv.Uni-Osnabrueck.DE" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753001AbaJ0NpW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Oct 2014 09:45:22 -0400
Received: from flach.fritz.box (ip4d160011.dynamic.kabel-deutschland.de [77.22.0.17])
	(authenticated bits=0)
	by smtp-auth.serv.Uni-Osnabrueck.DE (8.13.8/8.13.8) with ESMTP id s9RDNJH2026237
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Mon, 27 Oct 2014 14:23:21 +0100
Message-ID: <544E4747.2000008@uni-osnabrueck.de>
Date: Mon, 27 Oct 2014 14:23:19 +0100
From: Ansgar Hockmann-Stolle <Ansgar.Hockmann-Stolle@uni-osnabrueck.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: btrfs unmountable: read block failed check_tree_block; Couldn't read
 tree root
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

My btrfs system partition went readonly. After reboot it doesnt mount 
anymore. System was openSUSE 13.1 Tumbleweed (kernel 3.17.??). Now I'm 
on openSUSE 13.2-RC1 rescue (kernel 3.16.3). I dumped (dd) the whole 250 
GB SSD to some USB file and tried some btrfs tools on another copy per 
loopback device. But everything failed with:

kernel: BTRFS: failed to read tree root on dm-2

See http://pastebin.com/raw.php?i=dPnU6nzg.

Any hints where to go from here?

Ciao
	Ansgar
-- 
Ansgar Hockmann-Stolle, Universität Osnabrück, Rechenzentrum
Albrechtstraße 28, 49076 Osnabrück, Deutschland, Raum 31/E77B
+49 541 969-2749 (fax -2470), http://www.home.uos.de/anshockm
