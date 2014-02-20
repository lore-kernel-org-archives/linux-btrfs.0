Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.jrs-s.net ([173.230.137.22]:48798 "EHLO mail.jrs-s.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753802AbaBTQLH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 11:11:07 -0500
Received: from [192.168.100.50] (cpe-024-088-095-145.sc.res.rr.com [24.88.95.145])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: jim@jrs-s.net)
	by mail.jrs-s.net (Postfix) with ESMTPSA id 67A84D303
	for <linux-btrfs@vger.kernel.org>; Thu, 20 Feb 2014 11:11:05 -0500 (EST)
Message-ID: <53062918.8090909@jrs-s.net>
Date: Thu, 20 Feb 2014 11:11:04 -0500
From: Jim Salter <jim@jrs-s.net>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: btrfs-raid10 - stripes or blocks?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi list -

Can anybody tell me whether btrfs-raid10 reads and writes a stripe at a 
time, like traditional raid10, or whether it reads and writes individual 
redundant blocks like btrfs-raid1, but just locks particular disks as 
mirror pairs, and/or locks the order in which mirror pairs should be 
written to in sequence?

It occurs to me that this might be an important distinction for 
workloads with very high small random I/O - stripe reads and writes 
being at a disadvantage to individual blocks being read and written, 
when the requests are smaller than the stripe.

Apologies again if this is a question that should have an obvious 
answer, but as long as it took me to figure out that btrfs-raid1 is NOT 
much like traditional raid1, it seemed worth asking.
