Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37047 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554AbcDVWgW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 Apr 2016 18:36:22 -0400
Received: by mail-wm0-f46.google.com with SMTP id n3so46573482wmn.0
        for <linux-btrfs@vger.kernel.org>; Fri, 22 Apr 2016 15:36:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5704FACD.9040304@gmail.com>
References: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
	<CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
	<20160310023627.2e915667@natsu>
	<pan$9dde$acf9ba51$bb837cb8$8c954a04@cox.net>
	<CAD=QJKjkzh4U5Gmp=PJMiR8w3by12BVCDZ+MN2S+Ekk_EksjAg@mail.gmail.com>
	<CAD=QJKi7=R92UP4PKH4UAYH1HUB0Pr8DwO+MsyLNamKryYuZVA@mail.gmail.com>
	<CAJCQCtR60t=XN1vXaRoMA_YBAy=jje6ns9EoUO1wG_+Zk02LZw@mail.gmail.com>
	<CAD=QJKgrBXCXjP4vEzsGtO9oYN7LQ1titFatCYhmLbZea8_W0w@mail.gmail.com>
	<5704FACD.9040304@gmail.com>
Date: Fri, 22 Apr 2016 18:36:19 -0400
Message-ID: <CAD=QJKgpB83cjS-+_DYxdjAnONXa=UpqFEp0mKQPrg7-Zdt_1A@mail.gmail.com>
Subject: Re: dstat shows unexpected result for two disk RAID1
From: Nicholas D Steeves <nsteeves@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Everyone, thank you very much for helping me to learn more.  Getting
up to speed takes forever!  I posted an idea relating to this thread,
but it's more read latency rather than throughput related, but I'm not
sure what the right way to link overlapping threads is, so here is how
to find it:

Date: Fri, 22 Apr 2016 18:14:00 -0400
Message-ID: <CAD=QJKgJ9JAgZAOSivJTL-bcLbdkP6UqGb0i6g=fS9j6XKtcLA@mail.gmail.com>
Subject: Re: [PATCH v8 00/27][For 4.7] Btrfs: Add inband (write time)
 de-duplication framework

WRT the original AG balanced IO optimisation problem, should I spend
most of my time reading disk-io.c while looking for opportunities to
optimize multi-device reads, while consulting xfs_file.c and
xfs_super.c, or just xfs_super.c?

Thanks,
Nicholas
