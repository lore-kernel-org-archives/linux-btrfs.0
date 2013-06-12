Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:49041 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573Ab3FLABR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Jun 2013 20:01:17 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id E95C19A067E
	for <linux-btrfs@vger.kernel.org>; Tue, 11 Jun 2013 18:01:16 -0600 (MDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>, Eric Sandeen <sandeen@redhat.com>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130611232446.GA8389@lenny.home.zabbo.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <1370992519-21369-1-git-send-email-sandeen@redhat.com>
 <20130611232446.GA8389@lenny.home.zabbo.net>
Message-ID: <20130612000114.4914.15402@localhost.localdomain>
Subject: Re: [PATCH 0/3] Btrfs-progs: make some subdirs
Date: Tue, 11 Jun 2013 20:01:14 -0400
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Quoting Zach Brown (2013-06-11 19:24:46)
> On Tue, Jun 11, 2013 at 06:15:16PM -0500, Eric Sandeen wrote:
> > These are some patches I've been sitting on for a while that I think
> > clean up the btrfs-progs tree a bit; there are still quite a few files
> > left in the top-level dir, but moving tests & cmd files into cmd/
> > seems to clean things up a bit.  Curious to see what people think.
> 
> Seems reasonable to me.
> 
> > This is just file-moves and makefile-mangling, no code changes.
> 
> I guess .gitignore should also be updated.
> 
> > (a common/ or similar later on to hold kernel copies would probably
> > be the next move if this all looks reasonable)
> 
> kernel_import_no_touching/ ? :)

dangerdonteverchange?

I'd actually just go for kernel_import.  It would be nice if git had a
way to make the files readonly.

-chris

