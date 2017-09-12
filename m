Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49811 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751289AbdILLkO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Sep 2017 07:40:14 -0400
Date: Tue, 12 Sep 2017 13:38:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: btrfs-progs task tracking on github
Message-ID: <20170912113842.GI14538@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170908173622.GU31874@twin.jikos.cz>
 <730f6392-f156-ce05-0911-d1bf07ebfe57@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <730f6392-f156-ce05-0911-d1bf07ebfe57@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 09, 2017 at 08:13:04AM +0800, Qu Wenruo wrote:
> > [1] https://github.com/kdave/btrfs-progs/projects
> 
> This looks quite good.
> 
> BTW, is that only repo owner be able to modify the status?

We'll have to find out, but I think it's possible. There's Collaborators
tab in settings, where I could invite people.  I'll see if this could be
limited to the projects. In the meantime I'll update the status and add
new project tasks myself.

> In fact I found that some projects like offline scrub doesn't show up in 
> either WIP or TODO list.

Yeah, the list is not complete, so please open an issue with a brief
description and link to the patchset. The project items can be created
independently and connected to the issues.
