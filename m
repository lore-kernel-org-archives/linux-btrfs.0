Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbaBNQj0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Feb 2014 11:39:26 -0500
Date: Fri, 14 Feb 2014 17:39:25 +0100
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Koen De Wit <koen.de.wit@oracle.com>, xfs@oss.sgi.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests: test for atime-related mount options
Message-ID: <20140214163925.GW16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1392305016-7424-1-git-send-email-koen.de.wit@oracle.com>
 <52FCF60F.6030703@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52FCF60F.6030703@sandeen.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 13, 2014 at 10:42:55AM -0600, Eric Sandeen wrote:
> > +cat /proc/mounts | grep "$SCRATCH_MNT" | grep relatime >> $seqres.full
> > +[ $? -ne 0 ] && echo "The relatime mount option should be the default."
> 
> Ok, I guess "relatime" in /proc/mounts is from core vfs code and
> should be there for the foreseeable future, so seems ok.
> 
> But - relatime was added in v2.6.20, and made default in 2.6.30.  So
> testing older kernels may not go as expected; it'd probably be best to
> catch situations where relatime isn't available (< 2.6.20) or not
> default (< 2.6.30), by explicitly mounting with relatime, and skipping
> relatime/strictatime tests if that fails?

Is there some consensus what's the lowest kernel version to be supported
by xfstests? 2.6.32 is the lowest base for kernels in use today, so
worrying about anything older does not seem necessary.
