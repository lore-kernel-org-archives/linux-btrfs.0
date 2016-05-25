Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54357 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbcEYLMM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 May 2016 07:12:12 -0400
Date: Wed, 25 May 2016 13:11:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: utils: use better wrappered random generator
Message-ID: <20160525111138.GP29147@suse.cz>
Reply-To: dsterba@suse.cz
References: <1463973049-3480-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160523120112.GK29147@twin.jikos.cz>
 <f9d00b26-b0d7-c720-9dcf-4c4268a9ff75@cn.fujitsu.com>
 <20160524095155.GN29147@twin.jikos.cz>
 <913572bb-72f3-1428-f50c-4dc338d5c528@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <913572bb-72f3-1428-f50c-4dc338d5c528@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 25, 2016 at 08:33:45AM +0800, Qu Wenruo wrote:
> 
> 
> David Sterba wrote on 2016/05/24 11:51 +0200:
> > On Tue, May 24, 2016 at 08:31:01AM +0800, Qu Wenruo wrote:
> >>> This could be made static (with thread local storage) so the state does
> >>> not get regenerated all the time. Possibly it could be initialize from
> >>> some true random source, not time or pid.
> >>
> >> I also considered true random source like /dev/random, but since it's
> >> possible to wait for entropy pool, it would be quite slow and confusing
> >> for users.
> >
> > How would it be confusing? We'll once seed the random generator from
> > /dev/random, reading 3 * 16bit for the nrand generator context.
> 
> Reading from /dev/random may sleep, until the entropy pool is filled.

I know, but does this apply in our case? We're going to get just a few
bytes to seed.  I want to avoid inventing own random number generation
schemes, so we'll use a standard random number source or API.

/dev/random gives about 1-2MB/s of random data on several machines I've
tried.
