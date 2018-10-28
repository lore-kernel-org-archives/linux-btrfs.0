Return-Path: <SRS0=kVXZ=NI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE340C46475
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Oct 2018 01:46:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F51E207DD
	for <linux-btrfs@archiver.kernel.org>; Sun, 28 Oct 2018 01:46:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F51E207DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=merlins.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbeJ1K3I (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 28 Oct 2018 06:29:08 -0400
Received: from magic.merlins.org ([209.81.13.136]:57607 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbeJ1K3I (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Oct 2018 06:29:08 -0400
Received: from svh-gw.merlins.org ([173.11.111.145]:41218 helo=legolas.merlins.org)
        by mail1.merlins.org with esmtps 
        (Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.87 #1)
        id 1gGa9U-0007W1-IZ; Sat, 27 Oct 2018 18:46:08 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
        (envelope-from <marc@merlins.org>)
        id 1gGa9T-00039P-Br; Sat, 27 Oct 2018 18:46:03 -0700
Date:   Sat, 27 Oct 2018 18:46:03 -0700
From:   Marc MERLIN <marc@merlins.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Message-ID: <20181028014603.dhwx3j4cgi4pl3an@merlins.org>
References: <20181024003613.q5bxmqm4hh5xbgmf@merlins.org>
 <a8500d2d-2747-f250-75a8-2ec4c0533c6c@gmx.com>
 <20181027174245.4isfcb6nv4pkklmd@merlins.org>
 <25bf6019-c4e8-1d36-e475-b37f79aecc59@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25bf6019-c4e8-1d36-e475-b37f79aecc59@gmx.com>
X-Sysadmin: BOFH
X-URL:  http://marc.merlins.org/
User-Agent: NeoMutt/20160916 (1.7.0)
X-SA-Exim-Connect-IP: 173.11.111.145
X-SA-Exim-Mail-From: marc@merlins.org
Subject: Re: Have 15GB missing in btrfs filesystem.
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun, Oct 28, 2018 at 07:27:22AM +0800, Qu Wenruo wrote:
> > I can't drop all the snapshots since at least two is used for btrfs
> > send/receive backups.
> > However, if I delete more snapshots, and do a full balance, you think
> > it'll free up more space?
> 
> No.
> 
> You're already too worried about an non-existing problem.
> Your fs looks pretty healthy.

Thanks both for the answers. I'll go back and read them more carefully
later to see how I can adjust my monitoring but basically I hit the 90%
space used in df alert, and I know that once I get close to full, or
completely full, very bad things happen with btrfs, making the system
sometimes so unusable that it's very hard to reclaim space and fix the
issue (not counting that if you have btrfs send snapshots, you're forced
to break the snapshot relationship and start over since deleting data
does not reclaim blocks that are obviously still marked as used by the
last snapshot that was sent to the backup server).

Long story short, I try very hard to not ever hit this problem again :)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
