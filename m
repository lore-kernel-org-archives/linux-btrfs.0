Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f179.google.com ([209.85.220.179]:42851 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbaHCSxB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Aug 2014 14:53:01 -0400
Received: by mail-vc0-f179.google.com with SMTP id hq11so9710285vcb.10
        for <linux-btrfs@vger.kernel.org>; Sun, 03 Aug 2014 11:53:00 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 3 Aug 2014 14:53:00 -0400
Message-ID: <CAPDOMVj_ZdH0-1st_=VPfmmPqqi7DC0r+k3o2-df_rOf-Eybfw@mail.gmail.com>
Subject: Threads being NUMA aware
From: Nick Krause <xerofoify@gmail.com>
To: "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am wondering if the project for threads being NUMA aware is still
value as after reading it.
It seems to be obsolete due to it being directly supported in work
queues  by another kernel
layer.
Regards Nick
