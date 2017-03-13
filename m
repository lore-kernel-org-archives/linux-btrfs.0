Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58920 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753258AbdCMRSX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 13:18:23 -0400
Date: Mon, 13 Mar 2017 18:17:45 +0100
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: misc-tests: Superblock corruption and
 recovery using backup.
Message-ID: <20170313171745.GO14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170215205024.GA2486@giis.co.in>
 <f0b8ba50-4135-4bca-e5c4-0ff99d598e21@cn.fujitsu.com>
 <20170216223341.GA23272@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170216223341.GA23272@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 17, 2017 at 04:03:41AM +0530, Lakshmipathi.G wrote:
> On Thu, Feb 16, 2017 at 09:05:02AM +0800, Qu Wenruo wrote:
> > 
> > 
> > At 02/16/2017 04:50 AM, Lakshmipathi.G wrote:
> > >Signed-off-by: Lakshmipathi.G <Lakshmipathi.G@giis.co.in>
> > 
> > Looks good to me.
> > 
> > Reviewed by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> > 
> > BTW, it would be better to have some commit message.
> 
> ok, sent the v3 patch with commit message.

It's not necessary if the Subject says it all, so the changelog does not
simply repeat it.
