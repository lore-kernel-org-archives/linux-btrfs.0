Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48707 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751571AbdIJNSn (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 10 Sep 2017 09:18:43 -0400
Date: Sun, 10 Sep 2017 06:18:32 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: quwenruo@cn.fujitsu.com, Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>
Message-ID: <20170910131832.kgogo7y62td6l7tb@merlins.org>
References: <20170905010531.rfvun5isjwrb5ur5@merlins.org>
 <75b0ebd3-41ea-7f45-bec4-f7d9ec6efee1@gmx.com>
 <20170905025556.GA6392@merlins.org>
 <92e0486d-a7b5-01f8-5ef4-6773f8939bec@gmx.com>
 <20170905144525.rzvncaxil2enxjwe@merlins.org>
 <20170909174426.dvifafqeuqy4axpx@merlins.org>
 <b2eb3d47-e30a-d938-c879-2aaec38e749a@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <b2eb3d47-e30a-d938-c879-2aaec38e749a@gmx.com>
Subject: Re: btrfs check --repair now runs in minutes instead of hours?
 aborting
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 10, 2017 at 02:01:58PM +0800, Qu Wenruo wrote:
> 
> 
> On 2017年09月10日 01:44, Marc MERLIN wrote:
> > So, should I assume that btrfs progs git has some issue since there is
> > no plausible way that a check --repair should be faster than a regular
> > check?
> 
> Yes, the assumption that repair should be no faster than RO check is
> correct.
> Especially for clean fs, repair should just behave the same as RO check.
> 
> And I'll first submit a patch (or patches) to output the consumed time for
> each tree, so we could have a clue what is going wrong.
> (Digging the code is just a little too boring for me)

Cool. Let me know when I should sync and re-try.
In the meantime, though, my check --repair went back to 170mn after
triggering an FS bug for Josef, so it seems back to normal.

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
