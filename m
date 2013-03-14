Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932588Ab3CNAER (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 20:04:17 -0400
Date: Wed, 13 Mar 2013 17:04:14 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/10] restore: Add regex matching of paths and files to
 be restored
Message-ID: <20130314000414.GB3565@lenny.home.zabbo.net>
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com>
 <1363109897-7931-7-git-send-email-jbacik@fusionio.com>
 <20130313213112.GA3565@lenny.home.zabbo.net>
 <20130313233456.3393.qmail@stuge.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130313233456.3393.qmail@stuge.se>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > > restore -m '^/(|home(|/username(|/Desktop(|/.*))))$' /dev/sdb2 /output
> > 
> > But that example is just bonkers
> 
> I agree ugly, but why bonkers (I understand that to mean silly) ?

Well, I guess I mean that it's so ugly that we can't reasonably expect
people to use it :).

> I like the idea better than my regex. The implementation doing
> matching should however iterate over all path components, so that
> it's not neccessary to do
> 
> -g / -g /home -g /home/username -g /home/username/Desktop -g '/home/username/Desktop/*'
> 
> but to make this suffice:
> 
> -g '/home/username/Desktop/*'
> 
> Chopping up the string is easy enough.

Yeah, agreed.  It's annoying that we have to do this by hand :/.

- z
