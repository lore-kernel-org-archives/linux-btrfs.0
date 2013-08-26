Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:14848 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752591Ab3HZWJx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 18:09:53 -0400
Date: Mon, 26 Aug 2013 15:09:47 -0700
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: add support for asserts
Message-ID: <20130826220947.GI26818@lenny.home.zabbo.net>
References: <1377550566-10941-1-git-send-email-jbacik@fusionio.com>
 <20130826215326.GH26818@lenny.home.zabbo.net>
 <521BD07B.2050600@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <521BD07B.2050600@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > 	#ifdef BTRFS_ASSERT
> > 	#define btrfs_assert(cond)  BUG_ON(!(cond))
> > 	#else
> > 	#define btrfs_assert(cond)  do { if (cond) ; } while (0)
> > 	#endif
> 
> I think the only downside is that the BUG_ON() won't print the
> conditional that failed, IIRC.

Sure, if you wanted to go the heavier informative route.  I might also
add format and args in that case.

- z
