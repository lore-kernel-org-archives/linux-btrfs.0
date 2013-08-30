Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab3H3VEd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 17:04:33 -0400
Date: Fri, 30 Aug 2013 14:04:31 -0700
From: Zach Brown <zab@redhat.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 15/15] btrfs-progs: use NULL instead of 0
Message-ID: <20130830210431.GV26818@lenny.home.zabbo.net>
References: <1376522205-16992-1-git-send-email-zab@redhat.com>
 <1376522205-16992-16-git-send-email-zab@redhat.com>
 <20130830162554.GP23113@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130830162554.GP23113@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 30, 2013 at 06:25:54PM +0200, David Sterba wrote:
> On Wed, Aug 14, 2013 at 04:16:45PM -0700, Zach Brown wrote:
> > +	{ NULL, 0, NULL, 0}
> 
> > +		NULL_CMD_STRUCT,
> 
> It's always the last item, so I think the comma should go away,
> currently it's mixed. I'll fix it during commit, too trivial to bother
> you.

Agreed, I'm cool with whatever you prefer.

Thanks for merging these!

- z
