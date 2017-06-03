Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53278 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750935AbdFCHB5 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 3 Jun 2017 03:01:57 -0400
Date: Sat, 3 Jun 2017 15:01:54 +0800
From: Eryu Guan <eguan@redhat.com>
To: dsterba@suse.cz
Cc: Nikolay Borisov <nborisov@suse.com>, Omar Sandoval <osandov@osandov.com>,
        fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] generic: test Btrfs delalloc accounting overflow
Message-ID: <20170603070154.GE19952@eguan.usersys.redhat.com>
References: <49a0c7551c337566be29b2c073ba0be57779d321.1496391726.git.osandov@fb.com>
 <9f328b7d-5d07-a72f-72b1-bf334fd80a02@suse.com>
 <20170602124652.GJ12135@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170602124652.GJ12135@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 02, 2017 at 02:46:52PM +0200, David Sterba wrote:
> On Fri, Jun 02, 2017 at 12:07:37PM +0300, Nikolay Borisov wrote:
> > > +# Make sure that we didn't leak any metadata space.
> > > +if [[ $FSTYP = btrfs ]]; then
> > > +	uuid="$(findmnt -n -o UUID "$TEST_DIR")"
> > 
> > if we are on btrfs and we don't have findmnt this test will likely fail.
> > Perhaps include a _require_command findmnt
> 
> I think utilities like findmnt should be checked at the beginning of the
> whole testuiste, not in each test that uses them. As findmnt is part of

Agreed. I think we can define a FINDMNT_PROG in common/config and refuse
to run any test if it's mising, as what we did to $MOUNT_PROG and other
must-have commands. (There's already a bare call to findmnt in
common/rc, change it to call $FINDMNT_PROG too).

We can do this in a separate patch.

Thanks,
Eryu

> util-linux, missing it would also mean that eg 'mount' is missing.
> Highly unlikely.
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
