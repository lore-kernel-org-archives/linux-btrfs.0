Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbaHDSfV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Aug 2014 14:35:21 -0400
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s74IZKRY005201
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Aug 2014 14:35:20 -0400
Date: Mon, 4 Aug 2014 11:35:19 -0700
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 03/12] btrfs: handle errors from reading the quota tree
 root
Message-ID: <20140804183519.GB18659@lenny.home.zabbo.net>
References: <1406934766-16974-1-git-send-email-sandeen@redhat.com>
 <1406934766-16974-4-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1406934766-16974-4-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 01, 2014 at 06:12:37PM -0500, Eric Sandeen wrote:
> Reading the quota tree root may fail with ENOENT
> if there is no quota, which is fine, but the code was
> ignoring every other error as well, which is not fine.

Kinda makes you want to write a test that would have caught this.

Kinda.

Also, if you're still keen to iterate on this series, it looks like this
pattern is copied and pasted a few times in open_ctree().  With
temporary root pointers for each block, for some reason.  A little
helper function could take a bite out of open_ctree().

- z
