Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx.bordeaux.inra.fr ([147.100.111.220]:27563 "EHLO
	mail-1.bordeaux.inra.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753329AbbFONAX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Jun 2015 09:00:23 -0400
Received: from [147.100.98.136] ([147.100.98.136])
	(authenticated bits=0)
	by mail-1.bordeaux.inra.fr (/8.14.4) with ESMTP id t5FClNeB011187
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NOT)
	for <linux-btrfs@vger.kernel.org>; Mon, 15 Jun 2015 14:47:24 +0200 (CEST)
Message-ID: <557EC95C.8020902@bordeaux.inra.fr>
Date: Mon, 15 Jun 2015 14:47:24 +0200
From: Tovo Rabemanantsoa <tovo.rabemanantsoa@bordeaux.inra.fr>
MIME-Version: 1.0
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Bad performance with near-full FS
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,
By browsing this list's archive, I've found a thread initiated by
Charles Cazabon entitled: "Oddly slow read performance with near-full
largish FS."
Actually, I'm living the same experience but with a not so large FS
(256GB on a SSD). Indeed, when I have less than 1GB of free space, the
applications (thunderbird, thunar ...) on the machine become awfully
slow but remain normal if I make some cleaning.
Is it due to the FS or because it's an SSD hard disk ?
Thanks in advance

-- 
Tovo J. Rabemanantsoa
IT Manager
Quality correspondent
INRA - UMR ISPA [Interactions Sol Plante Atmosphère]
Villenave d'Ornon - Gironde, France
+33 5 57 12 24 09
