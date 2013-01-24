Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749Ab3AXRit (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 12:38:49 -0500
Date: Thu, 24 Jan 2013 18:38:46 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>, David Sterba <dsterba@suse.cz>,
        Josef Bacik <JBacik@fusionio.com>, bo.li.liu@oracle.com,
        miaox@cn.fujitsu.com,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: put csums on the right ordered extent
Message-ID: <20130124173845.GR28263@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1358887535-7241-1-git-send-email-jbacik@fusionio.com>
 <20130123110107.GG28263@twin.jikos.cz>
 <20130123152106.GI28263@twin.jikos.cz>
 <20130123235709.GB3752@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130123235709.GB3752@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 23, 2013 at 06:57:09PM -0500, Chris Mason wrote:
> Looks like Josef saw the same, so we have two different bugs (missing
> crcs vs incorrect crcs).  Josef mentioned a much faster test for the
> incorrect crcs...Josef what was that test?

Yeah, 2 bugs, this patch fixed the incorrect csums with DIO, your
scriptlet was able to trigger it reliably.

I don't see a mail from Josef about the 2nd problem, so let me tell the
story:

I've tested plain 3.7 with the script and also with the repeated
xfstests (that reproduced the 1st csum problem) -- all clear after 5.5
hours. So we took it as a first good. All suspects in the post 3.7
queue. Josef had a quick reproducer and bisected it to commit

31e502298d80e2af9001d17dc419a3fd4b0bebef
Author:     Liu Bo <bo.li.liu@oracle.com>

Btrfs: put raid properties into global table

Raid properties can be shared among raid calculation code, we can put
them into a global table to keep it simple.

https://patchwork.kernel.org/patch/1781061/
---

Which mistakenly specified 0 as a maximum number of devices in single
profile and was fixed by Miao later on, but the fix was not merged due
to Josef debugging the 1st csum problem.

https://patchwork.kernel.org/patch/1987481/

-	{ 1, 1, 0, 1, 1, 1 /* single */ },
+	{ 1, 1, 1, 1, 1, 1 /* single */ },

does indeed fix the 2nd bug.

The reproducer that worked for me was to create raid0/raid0 filesystem,
run the 50x fsx DIO load and do balance convert to single/single. Then
fsx fail.

cheers,
david
