Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.render-wahnsinn.de ([198.245.60.114]:36490 "EHLO
	mail.render-wahnsinn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbbHGIuh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Aug 2015 04:50:37 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.render-wahnsinn.de (Postfix) with ESMTP id 2B76F1B73B62
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2015 10:50:35 +0200 (CEST)
Received: from mail.render-wahnsinn.de ([127.0.0.1])
	by localhost (render-wahnsinn.de [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id GGCimoLJQp3Y for <linux-btrfs@vger.kernel.org>;
	Fri,  7 Aug 2015 10:50:34 +0200 (CEST)
Received: from [192.168.43.250] (unknown [212.200.65.243])
	by mail.render-wahnsinn.de (Postfix) with ESMTPSA id 6DB861B73B5C
	for <linux-btrfs@vger.kernel.org>; Fri,  7 Aug 2015 10:50:34 +0200 (CEST)
Message-ID: <55C47136.2080402@render-wahnsinn.de>
Date: Fri, 07 Aug 2015 10:49:58 +0200
From: Robert Krig <robert.krig@render-wahnsinn.de>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs raid1 metadata, single data
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I was wondering.

What exactly is contained in btrfs metadata?

I've read about some users setting up their btrfs volumes as
data=single, but metadata=raid1

Is there any actual benefit to that? I mean, if you keep your data as
single, but have multiple copies of metadata, does that still allow you
to recover from data corruption? Or is metadata redundancy a benefit to
ensure that your btrfs volume remains mountable/readable?


