Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from foo.stuge.se ([212.116.89.98]:50398 "EHLO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932359Ab3CMXlj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Mar 2013 19:41:39 -0400
Message-ID: <20130313233456.3393.qmail@stuge.se>
Date: Thu, 14 Mar 2013 00:34:56 +0100
From: Peter Stuge <peter@stuge.se>
To: Zach Brown <zab@redhat.com>
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/10] restore: Add regex matching of paths and files
	to be restored
References: <1363109897-7931-1-git-send-email-jbacik@fusionio.com> <1363109897-7931-7-git-send-email-jbacik@fusionio.com> <20130313213112.GA3565@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130313213112.GA3565@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Zach,

Zach Brown wrote:
> > In order to restore only a single folder somewhere in the btrfs
> > tree, it is unfortunately neccessary to construct a slightly
> > nontrivial regex, e.g.:
> > 
> > restore -m '^/(|home(|/username(|/Desktop(|/.*))))$' /dev/sdb2 /output
> 
> But that example is just bonkers

I agree ugly, but why bonkers (I understand that to mean silly) ?


> and suggests that we should also support globs for fnmatch(3).
> (-g is for glob? :))

I like the idea better than my regex. The implementation doing
matching should however iterate over all path components, so that
it's not neccessary to do

-g / -g /home -g /home/username -g /home/username/Desktop -g '/home/username/Desktop/*'

but to make this suffice:

-g '/home/username/Desktop/*'

Chopping up the string is easy enough.


> > +	if (match_regstr) {
> > +		ret = regcomp(&match_reg, match_regstr, match_cflags);
> 
> And this should probably be in a helper function.  Especially if it
> also grows fnmatch() support.

I agree. Maybe I'll take some time to make the changes tomorrow.


//Peter
