Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162929Ab3DEWs6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 5 Apr 2013 18:48:58 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r35MmvKM026479
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 18:48:57 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id r35Mmu8Y013896
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-btrfs@vger.kernel.org>; Fri, 5 Apr 2013 18:48:57 -0400
Message-ID: <515F54D8.4050903@redhat.com>
Date: Fri, 05 Apr 2013 17:48:56 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: How are userspace & kernelspace kept in sync?
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

One thing led to another in poking around the code, and I realized
that while userspace has lots of code copied from the kernel, it
was last copied in 2008, in many cases.  ;)

What's the plan here, how are userspace & kernelspace to be kept
in sync?

New features fairly obviously hit both, but what about bugfixes
that hit one codebase or the other?

Is it clear (to anyone) which code needs to be synced?

Should it be done as a wholesale sync-up/rebase from time to
time, or should commits be merged from one to the other?

Just wondering,
Thanks,
-Eric
