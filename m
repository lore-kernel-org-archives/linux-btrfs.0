Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab3AaAPt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jan 2013 19:15:49 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0V0FmJp011993
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Wed, 30 Jan 2013 19:15:49 -0500
Date: Wed, 30 Jan 2013 16:15:47 -0800
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/11] btrfs: misc fixes and cleanups
Message-ID: <20130131001547.GB14246@lenny.home.zabbo.net>
References: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359593702-53056-1-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 30, 2013 at 06:54:51PM -0600, Eric Sandeen wrote:
> A handful of fixes from looking at Coverity static checker
> results, and the surrounding code.  Of varying severity,
> but all worthwhile I hope.
> 
> Full disclosure: compile-tested only, but nothing too crazy
> in here I think.

Yeah, this all seems pretty reasonable to me.

Signed-off-by: Zach Brown <zab@redhat.com>

- z
