Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52629 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933301AbcCIRLr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Mar 2016 12:11:47 -0500
Date: Wed, 9 Mar 2016 18:11:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH] Documentation: btrfs: remove usage specific information
Message-ID: <20160309171126.GB18908@suse.cz>
Reply-To: dsterba@suse.cz
References: <1457456686-30474-1-git-send-email-dsterba@suse.com>
 <56DF7BDB.8000109@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56DF7BDB.8000109@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 09, 2016 at 10:26:51AM +0900, Satoru Takeuchi wrote:
> > +that maintains information about administration tasks, frequently asked
> > +questions, use cases, mount options, comprehensible changelogs, features,
> > +manual pages, source code repositories, contacts etc.
> 
> About mount options, we also have "man 5 btrfs" and it's
> newer than wiki page's one.
> 
> https://www.mail-archive.com/linux-btrfs%40vger.kernel.org/msg34545.html
> commit 26341f734d6d ("btrfs-progs: add mount options to btrfs-mount.5")
> 
> Last update:
>  - Btrfs wiki -> Mount options: Sep 19 2015
>  - btrfs-man5.asciidoc: Jan 11 2016

I'm consolidating the documentation to a single source if possible, at
the moment the wiki page for mount option still exists and lags behind
the manual page. Also the wiki page btrfs-mount hasn't been renamed to
btrfs-man5 and the contents.

The conversion scripts are at https://github.com/kdave/btrfs-wiki
(/git2wiki) . They're not perfect and sometimes produces strange
artifacts, so this is where it gets stuck.

> So, how about refer to "man 5 btrfs" from
> "Btrfs wiki -> Mount options -> List of options"
> and/or this document?

I'd prefer to update the wiki.
