Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:57532 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbaDEWCF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Apr 2014 18:02:05 -0400
Date: Sat, 5 Apr 2014 15:02:03 -0700
From: Marc MERLIN <marc@merlins.org>
To: cwillu <cwillu@cwillu.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 24/27] btrfs-progs: Convert man page for btrfs-zero-log
Message-ID: <20140405220203.GB13857@merlins.org>
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com> <1396427378-10487-25-git-send-email-quwenruo@cn.fujitsu.com> <20140404184620.GA12124@merlins.org> <CAE5mzvhTZ1bO_uoyz-ixsn29iznXRjzFkM5UfDBcFUdX0ov7RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAE5mzvhTZ1bO_uoyz-ixsn29iznXRjzFkM5UfDBcFUdX0ov7RQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 05, 2014 at 04:00:27PM -0600, cwillu wrote:
> >> +'btrfs-zero-log' will remove the log tree if log tree is corrupt, which will
> >> +allow you to mount the filesystem again.
> >> +
> >> +The common case where this happens has been fixed a long time ago,
> >> +so it is unlikely that you will see this particular problem.
> >
> > A note on this one: this can happen if your SSD rites things in the
> > wrong order or potentially writes garbage when power is lost, or before
> > locking up.
> > I hit this problem about 10 times and it wasn't a btrfs bug, just the
> > drive doing bad things.
> 
> And -o recovery didn't work around it?  My understanding is that -o
> recovery will skip reading the log.

Maybe it does, but if you're trying to mount your root filesystem to boot
your laptop, that's not super useful since -o recovery is indeed a read only
recovery mode.
btrfs-zero-log just cleans the last log entry and gave me back a fully working
read/write filesystem each time.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
