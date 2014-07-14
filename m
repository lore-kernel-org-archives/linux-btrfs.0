Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:51201 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaGNCnT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 13 Jul 2014 22:43:19 -0400
Date: Sun, 13 Jul 2014 19:43:02 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: "Andrew E. Mileski" <andrewm@isoar.ca>, Duncan <1i5t5.duncan@cox.net>,
        Russell Coker <russell@coker.com.au>,
        Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Message-ID: <20140714024302.GD17968@merlins.org>
References: <20140713154514.GP10641@merlins.org>
 <53C3341C.5090504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53C3341C.5090504@cn.fujitsu.com>
Subject: Re: btrfs quotas related to OOM death problems on my 8GB server with
 both 3.15.1 and 3.14?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 14, 2014 at 09:36:28AM +0800, Qu Wenruo wrote:
> When you enable quota and create a subvolume, a qgroup(0/<subvol
> id>) will be created and bind to the newly created subvolume.
> But on the other hand, when you delete the subvolume, the qgroup
> will *not* be deleted automatically.
> So you need to remove the qgroup manually.
> 
> More info can be found in the btrfs wiki:
> https://btrfs.wiki.kernel.org/index.php/Quota_support#Known_issues

This was updated since I last looked at it, thanks for pointing that
out.

So there must be a leak that is related to how many qtrees you have.
Because even if I had 1600 qtrees, that shouldn't slowly eat up 6GB of
RAM, correct?

That said, I'll try the memleak detector you pointed me to, and read up
on how it's supposed to work.

Thanks for your help,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
