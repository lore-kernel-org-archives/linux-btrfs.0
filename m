Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56181 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751903AbcFOMzh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 08:55:37 -0400
Date: Wed, 15 Jun 2016 14:56:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Roman Mamedov <rm@romanrm.net>
Cc: Mark Fasheh <mfasheh@suse.de>, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, chris@suse.de,
        Josef Bacik <jbacik@fb.com>
Subject: Re: [PATCH v7 0/8] Inband dedupe for btrfs-progs
Message-ID: <20160615125610.GK6205@suse.cz>
Reply-To: dsterba@suse.cz
References: <1459492670-31596-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20160601213210.GK7633@wotan.suse.de>
 <20160602101634.55f9c1be@natsu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160602101634.55f9c1be@natsu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 02, 2016 at 10:16:34AM +0500, Roman Mamedov wrote:
> On Wed, 1 Jun 2016 14:32:10 -0700
> Mark Fasheh <mfasheh@suse.de> wrote:
> 
> > Can we please have seperate and obvious namespaces for in-band dedupe and
> > out-of-band dedupe commands? I realize that there is no oob-dedupe
> > funcationality in btrfs-progs today but I would like to avoid confusing
> > users in the case that this code hits btrfs-progs.
> > 
> > Specifically by this, I mean I'd like to see anything except 'dedupe' as the
> > btrfs command, so a user who sees 'btrfs dedupe ....' is not confusing the
> > two forms we have.
> > 
> > I don't personally care what other name is used and of course it could have
> > 'dedupe' in the name just not solely 'dedupe'. As a poor example, we could
> > call it 'btrfs inband-dedupe ...'.
> 
> There might be no such code added ever -- but everyone will be stuck with
> typing "inband-dedupe" instead of the simple and short "dedupe" forever
> because of this "future precaution".
> 
> At least make that "dedupe-inband", so that the shorthand form of "dedupe"
> also works for now, and only starts throwing a warning if any other subcommand
> starting with "dedupe" is added.

This sounds like a good idea to me. Alternatively it could be 'idedupe'
and if we ever need the out-of-band, we could call it like 'fdedupe'
(file dedupe).
