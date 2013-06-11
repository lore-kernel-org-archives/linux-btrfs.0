Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab3FKXYr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 19:24:47 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r5BNOkrL011434
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 19:24:47 -0400
Date: Tue, 11 Jun 2013 16:24:46 -0700
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Btrfs-progs: make some subdirs
Message-ID: <20130611232446.GA8389@lenny.home.zabbo.net>
References: <1370992519-21369-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370992519-21369-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 11, 2013 at 06:15:16PM -0500, Eric Sandeen wrote:
> These are some patches I've been sitting on for a while that I think
> clean up the btrfs-progs tree a bit; there are still quite a few files
> left in the top-level dir, but moving tests & cmd files into cmd/
> seems to clean things up a bit.  Curious to see what people think.

Seems reasonable to me.

> This is just file-moves and makefile-mangling, no code changes.

I guess .gitignore should also be updated.

> (a common/ or similar later on to hold kernel copies would probably
> be the next move if this all looks reasonable)

kernel_import_no_touching/ ? :)

- z
