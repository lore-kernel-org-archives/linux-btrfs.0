Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857AbcF0HYp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 27 Jun 2016 03:24:45 -0400
Date: Mon, 27 Jun 2016 15:24:38 +0800
From: Eryu Guan <eguan@redhat.com>
To: jeffm@suse.com
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/4] fstests: btrfs/124: test global metadata reservation
 reporting
Message-ID: <20160627072438.GR23649@eguan.usersys.redhat.com>
References: <1466780914-23884-1-git-send-email-jeffm@suse.com>
 <1466780914-23884-2-git-send-email-jeffm@suse.com>
 <20160627071647.GP23649@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160627071647.GP23649@eguan.usersys.redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 27, 2016 at 03:16:47PM +0800, Eryu Guan wrote:
> On Fri, Jun 24, 2016 at 11:08:32AM -0400, jeffm@suse.com wrote:
> > From: Jeff Mahoney <jeffm@suse.com>
> > 
[snip]
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter.btrfs
> > +
> > +_supported_fs btrfs
> > +_supported_os Linux
> > +_require_scratch
> > +
> > +_scratch_mkfs > /dev/null 2>&1
> > +_scratch_mount
> 
> There should be some kind of "_require_xxx" or something like that to
> _notrun if current running kernel doesn't have global metadata
> reservation report implemented.

Also need a _require_test_program call to make sure btrfs_ioctl_helper
is built and in src/ dir.

_require_test_program "btrfs_ioctl_helper"

Sorry, I missed it in first revlew.

Thanks,
Eryu
