Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57588 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753388AbaHSR3l (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Aug 2014 13:29:41 -0400
Date: Tue, 19 Aug 2014 19:29:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC] btrfs: Use backup superblocks if and only if the
 first superblock is valid but corrupted.
Message-ID: <20140819172938.GD1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1403841234-10393-1-git-send-email-quwenruo@cn.fujitsu.com>
 <53D17A88.5090905@fb.com>
 <53D46A8B.2030002@gmail.com>
 <53D5994F.4010605@cn.fujitsu.com>
 <53D5BB10.6070309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53D5BB10.6070309@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jul 27, 2014 at 10:53:04PM -0400, Austin S Hemmelgarn wrote:
> >>> But, for right now I'd prefer the admin get involved in using the backup
> >>> supers.  I think silently using the backups is going to lead to
> >>> surprises.
> >> Maybe there could be a mount non-default mount-option to use backup
> >> superblocks iff the first one is corrupted, and then log a warning
> >> whenever this actually happens?  Not handling stuff like this
> >> automatically really hurts HA use cases.
> >>
> >>
> > This seems better and comments also shows this idea.
> > What about merging the behavior into 'recovery' mount option or adding a
> > new mount option?
> Personally, I'd add a new mount option, but make recovery imply that option.

I agree with that, though we do not need introduce an extra option if
the meaning is denendent on 'recovery', but rather make it a mode of
recovery (and we could add more in the future). Eg.

$ mount -o recovery=sb

which would try to use all valid backup superblocks to mount.
