Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:41125 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751950AbeGCS6H (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jul 2018 14:58:07 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] btrfs: Check each block group has corresponding chunk at mount time
Date: Tue, 03 Jul 2018 20:58:05 +0200
Message-ID: <2541430.RJ1Yey9kW5@merkaba>
In-Reply-To: <b30b48c9-7e31-bde0-ea9d-10545a4ba613@suse.com>
References: <20180703080830.8300-1-wqu@suse.com> <e606ab9c-f855-b237-2426-56f3f100bae9@gmx.com> <b30b48c9-7e31-bde0-ea9d-10545a4ba613@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Nikolay Borisov - 03.07.18, 11:08:
> On  3.07.2018 11:47, Qu Wenruo wrote:
> > On 2018年07月03日 16:33, Nikolay Borisov wrote:
> >> On  3.07.2018 11:08, Qu Wenruo wrote:
> >>> Reported in https://bugzilla.kernel.org/show_bug.cgi?id=199837, if
> >>> a
> >>> crafted btrfs with incorrect chunk<->block group mapping, it could
> >>> leads to a lot of unexpected behavior.
> >>> 
> >>> Although the crafted image can be catched by block group item
> >>> checker
> >>> added in "[PATCH] btrfs: tree-checker: Verify block_group_item",
> >>> if one crafted a valid enough block group item which can pass
> >>> above check but still mismatch with existing chunk, it could
> >>> cause a lot of undefined behavior.
> >>> 
> >>> This patch will add extra block group -> chunk mapping check, to
> >>> ensure we have a completely matching (start, len, flags) chunk
> >>> for each block group at mount time.
> >>> 
> >>> Reported-by: Xu Wen <wen.xu@gatech.edu>
> >>> Signed-off-by: Qu Wenruo <wqu@suse.com>
> >>> ---
> >>> changelog:
> >>> 
> >>> v2:
> >>>   Add better error message for each mismatch case.
> >>>   Rename function name, to co-operate with later patch.
> >>>   Add flags mismatch check.
> >>> 
> >>> ---
> >> 
> >> It's getting really hard to keep track of the various validation
> >> patches you sent with multiple versions + new checks. Please batch
> >> everything in a topic series i.e "Making checks stricter" or some
> >> such and send everything again nicely packed, otherwise the risk
> >> of mis-merging is increased.
> > 
> > Indeed, I'll send the branch and push it to github.
> > 
> >> I now see that Gu Jinxiang from fujitsu also started sending
> >> validation fixes.
> > 
> > No need to worry, that will be the only patch related to that thread
> > of bugzilla from Fujitsu.
> > As all the other cases can be addressed by my patches, sorry Fujitsu
> > guys :)> 
> >> Also for evry patch which fixes a specific issue from one of the
> >> reported on bugzilla.kernel.org just use the Link: tag to point to
> >> the original report on bugzilla that will make it easier to relate
> >> the fixes to the original report.
> > 
> > Never heard of "Link:" tag.
> > Maybe it's a good idea to added it to "submitting-patches.rst"?
> 
> I guess it's not officially documented but if you do git log --grep
> "Link:" you'd see quite a lot of patches actually have a Link pointing
> to the original thread if it has sparked some pertinent discussion.
> In this case those patches are a direct result of a bugzilla
> bugreport so having a Link: tag makes sense.

For Bugzilla reports I saw something like

Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=43511

in a patch I was Cc´d to.

Of course that does only apply if the patch in question fixes the 
reported bug.

> In the example of the qgroup patch I sent yesterday resulting from
> Misono's report there was also an involved discussion hence I added a
> link to the original thread.
[…]
-- 
Martin


