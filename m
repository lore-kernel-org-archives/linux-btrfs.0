Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251Ab3I3Reo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Sep 2013 13:34:44 -0400
Date: Mon, 30 Sep 2013 10:34:40 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: don't delete ordered roots from list during
 cleanup
Message-ID: <20130930173440.GC30372@lenny.home.zabbo.net>
References: <1380314266-28871-1-git-send-email-jbacik@fusionio.com>
 <20130927231814.GB30372@lenny.home.zabbo.net>
 <20130930153602.GN18681@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130930153602.GN18681@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> So I _think_ we may need to truncate the ordered range in the inode as well, but
> I haven't had a consistent reproducer for this case.  I want to leave it like
> this for now until I'm sure we don't need the truncate and then we could
> probably just replace this with a test for FS_ERROR in finish_ordered_io.

*nod*, added to the list :)

- z
