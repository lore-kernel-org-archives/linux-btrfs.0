Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 17.mo6.mail-out.ovh.net ([46.105.36.150]:48126 "EHLO
	mo6.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752278AbaKLOEg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 09:04:36 -0500
Received: from mail617.ha.ovh.net (gw6.ovh.net [213.251.189.206])
	by mo6.mail-out.ovh.net (Postfix) with SMTP id E3DF5FFB4CF
	for <linux-btrfs@vger.kernel.org>; Wed, 12 Nov 2014 15:04:34 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.0 \(1990.1\))
Subject: Re: Quota question
From: Cyril Scetbon <cyril.scetbon@free.fr>
In-Reply-To: <EE8501C5-2A50-4E93-89F5-C08E28CE71DB@free.fr>
Date: Wed, 12 Nov 2014 15:04:28 +0100
Cc: linux-btrfs@vger.kernel.org
Message-Id: <928A4C3A-2CE4-48E5-8831-BE6C1685ED8B@free.fr>
References: <23550138-C487-44E1-AA4A-B3B951D778D1@free.fr> <F924EC8F-D124-4E6D-A8FE-E03D82A8DAB8@free.fr> <pan$db0e5$7ee7229b$da3a292b$c1219b2@cox.net> <CCA13B0E-D1EE-44D8-A634-FD17C2B22C72@free.fr> <pan$648cb$e6ca8d21$192128f6$95e500d3@cox.net> <967D58C4-46E1-4508-A5A9-A0835C18E87D@free.fr> <EE8501C5-2A50-4E93-89F5-C08E28CE71DB@free.fr>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Anyone on this ? There is an issue with quotas depending on the write rate. The more we can write before a sync, the more we can exceed quotas limits
-- 
Cyril SCETBON

> I did some new tests and the issue with quota exceeded comes from the fact that the data is not sync to disk : http://pastebin.com/fZdh2YRu

