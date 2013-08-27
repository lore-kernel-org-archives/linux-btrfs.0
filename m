Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from postman.teamix.net ([194.150.191.120]:35208 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751957Ab3H0N0y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 09:26:54 -0400
Received: from zimbra.of.teamix.net (unknown [172.21.242.23])
	by rproxy.teamix.net (Postfix) with ESMTP id 85AB87A099
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 15:20:17 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.of.teamix.net (Postfix) with ESMTP id 66F57123BD5
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 15:20:17 +0200 (CEST)
Received: from zimbra.of.teamix.net ([127.0.0.1])
	by localhost (zimbra.of.teamix.net [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id Zft7NPVZzoGC for <linux-btrfs@vger.kernel.org>;
	Tue, 27 Aug 2013 15:20:16 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by zimbra.of.teamix.net (Postfix) with ESMTP id 1232D123BD6
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 15:20:16 +0200 (CEST)
Received: from zimbra.of.teamix.net ([127.0.0.1])
	by localhost (zimbra.of.teamix.net [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id auh2I3byGjfF for <linux-btrfs@vger.kernel.org>;
	Tue, 27 Aug 2013 15:20:15 +0200 (CEST)
Received: from zimbra.of.teamix.net (zimbra.of.teamix.net [172.21.242.23])
	by zimbra.of.teamix.net (Postfix) with ESMTP id EB39E123BD5
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 15:20:15 +0200 (CEST)
Date: Tue, 27 Aug 2013 15:20:15 +0200 (CEST)
From: Martin Steigerwald <ms@teamix.de>
To: linux-btrfs@vger.kernel.org
Message-ID: <1865492918.2145268.1377609615453.JavaMail.zimbra@teamix.de>
In-Reply-To: <1242390564.2145156.1377608853484.JavaMail.zimbra@teamix.de>
Subject: Can BTRFS use Forward Correction Codes?
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi!

I just read

http://www.amplidata.com/pdf/The-RAID-Catastrophe.pdf


According to that – well marketing white paper – it offers huge advantages over just replicating the data several times.


What do you think about it?

Can BTRFS use Forward Correction Codes to allow scenarios like 4 out of 12 drives can fail? And can this provide an advantage over regular replication?

Ciao,
-- 
Martin Steigerwald - teamix GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90
