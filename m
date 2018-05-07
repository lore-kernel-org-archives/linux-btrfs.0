Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58052 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752211AbeEGLnC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 May 2018 07:43:02 -0400
Date: Mon, 7 May 2018 13:40:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Lu Fengqi <lufq.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 04/10] btrfs-progs: undelete-subvol: introduce
 is_subvol_intact
Message-ID: <20180507114021.GA32018@suse.cz>
Reply-To: dsterba@suse.cz
References: <20180327070658.13064-1-lufq.fnst@cn.fujitsu.com>
 <20180327070658.13064-5-lufq.fnst@cn.fujitsu.com>
 <c4bd3079-c431-4c99-f140-bb02493d708b@gmx.com>
 <89cfc2c1-b070-bc4f-cd0b-4be27f90ea08@cn.fujitsu.com>
 <9c7668bf-e5e1-44df-183f-e12b0d990422@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <9c7668bf-e5e1-44df-183f-e12b0d990422@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 07, 2018 at 10:20:57AM +0800, Qu Wenruo wrote:
> >>> +++ b/undelete-subvol.c
> >>> @@ -0,0 +1,53 @@
> >>> +/*
> >>> + * Copyright (C) 2018 Fujitsu.  All rights reserved.
> >>
> >> IIRC David will remove all such copy right line.
> >> Is there some principle about this, David?
> > 
> > Are you referring to this patchset that replace GPL boilerplate by SPDX?
> > https://patchwork.kernel.org/patch/10321621/
> > 
> > However, I haven't seen a similar patch in btrfs-progs.
> > 
> 
> Nope, I mean David will remove the Copyright (C) line when applying.
> Although I'm not completely sure.

Removing copyright notices should not be done without an ack from all
parties and I don't remove the copyright notices from patches if
present.

I personally do not understand and see the point of the explicit
mentions if we have the signed-off by in git history. Also, when the
file is touched by many different people over time, the line 'copyright
by Evil Company' looks like all the credit goes to the single entitiy.

There's a point if the code is copied from another source, like the
test/sha* code that's from an RFC.

So, I decided to not care too much about the copyright line as long as
there's a signed-off and authorship is GPL compatible.
