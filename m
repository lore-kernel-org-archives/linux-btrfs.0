Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbaIOM1K (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Sep 2014 08:27:10 -0400
Date: Mon, 15 Sep 2014 14:27:08 +0200
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@zabbo.net>, Anand Jain <Anand.Jain@oracle.com>,
        linux-btrfs@vger.kernel.org, wangshilong1991@gmail.com
Subject: Re: [PATCH] btrfs-progs: per-thread, per-call pretty buffer
Message-ID: <20140915122708.GE9715@suse.cz>
Reply-To: dsterba@suse.cz
References: <20130709202443.GJ18717@lenny.home.zabbo.net>
 <1373466615-30013-1-git-send-email-dsterba@suse.cz>
 <5408504C.1050203@oracle.com>
 <20140904194545.GI15881@lenny.home.zabbo.net>
 <54096204.70508@oracle.com>
 <20140905155501.GM15881@lenny.home.zabbo.net>
 <20140905162049.GF5636@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140905162049.GF5636@suse.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 05, 2014 at 06:20:49PM +0200, David Sterba wrote:
> On Fri, Sep 05, 2014 at 08:55:01AM -0700, Zach Brown wrote:
> > David, let me know if you want me to change anything or resend so you
> > don't have to pull this out of a reply in a thread.
> 
> Thanks, I'm now aware of the patch in the thread.

FYI, I'm going to add the fix to the 3.17 queue but there are other
changes to the unit printing interface that are in conflict with this.
My plan is to apply Zach's changes on top of that.
