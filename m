Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6297 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598Ab3AXTn2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 14:43:28 -0500
Date: Thu, 24 Jan 2013 11:42:38 -0800
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, gene@czarc.net
Subject: Re: [PATCH 10/10] Btrfs-progs: add show subcommand to subvol cli
Message-ID: <20130124194238.GE14246@lenny.home.zabbo.net>
References: <1358928771-31960-1-git-send-email-anand.jain@oracle.com>
 <1358928771-31960-11-git-send-email-anand.jain@oracle.com>
 <5100C156.6010107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5100C156.6010107@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> > +	if (sv_id == 5) {
> > +		printf("%s is btrfs root\n", fullpath);
> > +		close(fd);
> > +		close(mntfd);
> > +		free(mnt);
> > +		free(fullpath);
> > +		return 1;
> 
> Just wondering, at this point might a "goto out;" be cleaner error
> handling?  Every error case is getting longer ;)

No wondering needed!  This pattern is a source of bugs.  I'm hitting
cases in the static analysis reports of people adding return paths
without recognizing the pile of state they're expected to cleanup.

Use safe unwinding in one exit path at the end, please.  It's less
maddening to audit and less likely to fail over time.

- z
