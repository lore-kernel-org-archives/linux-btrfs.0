Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60751 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919Ab3FDWSD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 4 Jun 2013 18:18:03 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r54MI3IC017155
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Jun 2013 18:18:03 -0400
Received: from lenny.home.zabbo.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r54MI2Q2002655
	for <linux-btrfs@vger.kernel.org>; Tue, 4 Jun 2013 18:18:02 -0400
From: Zach Brown <zab@redhat.com>
To: linux-btrfs@vger.kernel.org
Subject: [PATCH 0/6] fix INT_MAX readdir hang, plus cleanups
Date: Tue,  4 Jun 2013 15:17:54 -0700
Message-Id: <1370384280-28652-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi gang,

I finally sat down to fix that readdir hang that has been in the back
of my mind for a while.  I *hope* that the fix is pretty simple: just
don't manufacture a fake f_pos, I *think* we can abuse f_version as an
indicator that we shouldn't return entries.  Does this look reasonable?

We still have the problem that we can generate valid large f_pos values
that can confuse 32bit userspace, but that's a different problem.  I
think we'll want filldir generation of EOVERFLOW like what exists for
large inodes. 

The rest of the patches are cleanups that I saw when absorbing the
code.  It's all lightly tested with xfstests but it wouldn't surprise
me if I missed something so review is appreciated.

Thanks!

- z
