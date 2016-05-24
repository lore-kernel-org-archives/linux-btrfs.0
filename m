Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52379 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755337AbcEXJw2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 May 2016 05:52:28 -0400
Date: Tue, 24 May 2016 11:51:55 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: utils: use better wrappered random generator
Message-ID: <20160524095155.GN29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463973049-3480-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160523120112.GK29147@twin.jikos.cz>
 <f9d00b26-b0d7-c720-9dcf-4c4268a9ff75@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f9d00b26-b0d7-c720-9dcf-4c4268a9ff75@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 24, 2016 at 08:31:01AM +0800, Qu Wenruo wrote:
> > This could be made static (with thread local storage) so the state does
> > not get regenerated all the time. Possibly it could be initialize from
> > some true random source, not time or pid.
> 
> I also considered true random source like /dev/random, but since it's 
> possible to wait for entropy pool, it would be quite slow and confusing 
> for users.

How would it be confusing? We'll once seed the random generator from
/dev/random, reading 3 * 16bit for the nrand generator context.

> So time with pid seems good enough.

Only as a fallback if /dev/random is not available at all.
