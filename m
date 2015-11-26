Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48579 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbbKZJcO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Nov 2015 04:32:14 -0500
Date: Thu, 26 Nov 2015 10:30:28 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, jeffm@suse.com
Subject: Re: [PATCH 00/25] Btrfs-convert rework to support native separate
Message-ID: <20151126093028.GP31035@suse.cz>
Reply-To: dsterba@suse.cz
References: <1447989869-24739-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151123173330.GH31035@twin.jikos.cz>
 <565424B8.3020502@cn.fujitsu.com>
 <20151125124235.GO31035@suse.cz>
 <5656547F.5050900@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5656547F.5050900@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 26, 2015 at 08:38:23AM +0800, Qu Wenruo wrote:
> > As far as the conversion support stays, it's not a problem of course. I
> > don't have a complete picture of all the actual merging conflicts, but
> > the idea is to provide the callback abstraction v2 to allow ext2 and
> > reiser plus allow all the changes of this pathcset.
> >
> Glad to hear that.
> 
> BTW, which reiserfs progs headers are you using?

Sorry I forgot to mention it, it's the latest git version,
https://git.kernel.org/cgit/linux/kernel/git/jeffm/reiserfsprogs.git/

Jeff hasn't released v3.6.25 yet. We have the git version in SUSE
distros so it works for me here.
