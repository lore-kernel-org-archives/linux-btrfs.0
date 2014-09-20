Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailgw12.technion.ac.il ([132.68.225.12]:53670 "EHLO
	mailgw12.technion.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429AbaITQWZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 20 Sep 2014 12:22:25 -0400
Received: from mail-lb0-f173.google.com (mail-lb0-f173.google.com [209.85.217.173])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	by roger.technion.ac.il (Postfix) with ESMTPSA id 11C0140248
	for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 19:11:52 +0300 (IDT)
Received: by mail-lb0-f173.google.com with SMTP id 10so2945421lbg.4
        for <linux-btrfs@vger.kernel.org>; Sat, 20 Sep 2014 09:11:53 -0700 (PDT)
MIME-Version: 1.0
Date: Sat, 20 Sep 2014 19:11:52 +0300
Message-ID: <CAOwCge2f+s0BdUXYnMuX_iyXLcsq-FtftqT-yf1GSvyhhT9kdg@mail.gmail.com>
Subject: Using two mirrored drives separately
From: Leonid Bloch <lb@techunix.technion.ac.il>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I am wondering: if I set up btrfs on two identical drives, with data
and metadata mirroring, will it be possible to use these drives
separately later on? Will just one of these drives work as a regular
btrfs-formatted single drive if connected to a different machine?

Thanks ahead,
Leonid.
