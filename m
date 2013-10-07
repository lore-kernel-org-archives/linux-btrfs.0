Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab3JGVnN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 7 Oct 2013 17:43:13 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r97LhCgD000731
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 7 Oct 2013 17:43:12 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>
Subject: [RFC] another round of static analysis fixes
Date: Mon,  7 Oct 2013 14:42:53 -0700
Message-Id: <1381182185-10896-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi friends, 

Eric imported a newer git snapshot of btrfs-progs into Red Hat's
universe which kicked off a static analysis run which found a bunch
of problems.  This series is my attempt to fix the warnings that I
agreed were either real bugs or messy code to clean up.

This is against Dave's integration-next as of:

commit 62f6537f8c9149283844c5e93a296e147c266247
Date:   Fri Sep 13 19:32:23 2013 +0800

And totally untested.  Review please?

- z
