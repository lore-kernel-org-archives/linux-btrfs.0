Return-Path: <SRS0=HsfQ=2J=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A619C43603
	for <linux-btrfs@archiver.kernel.org>; Thu, 19 Dec 2019 20:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A9BF2467E
	for <linux-btrfs@archiver.kernel.org>; Thu, 19 Dec 2019 20:06:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726930AbfLSUGM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 19 Dec 2019 15:06:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:44752 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726906AbfLSUGM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 19 Dec 2019 15:06:12 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 91984AF57;
        Thu, 19 Dec 2019 20:06:10 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id F0C50DA939; Thu, 19 Dec 2019 21:06:07 +0100 (CET)
Date:   Thu, 19 Dec 2019 21:06:07 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Dennis Zhou <dennis@kernel.org>
Cc:     David Sterba <dsterba@suse.cz>, David Sterba <dsterba@suse.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v6 00/22] btrfs: async discard support
Message-ID: <20191219200607.GQ3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Dennis Zhou <dennis@kernel.org>,
        David Sterba <dsterba@suse.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Omar Sandoval <osandov@osandov.com>, kernel-team@fb.com,
        linux-btrfs@vger.kernel.org
References: <cover.1576195673.git.dennis@kernel.org>
 <20191217145541.GE3929@suse.cz>
 <20191218000600.GB2823@dennisz-mbp>
 <20191219020337.GA25072@dennisz-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219020337.GA25072@dennisz-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 18, 2019 at 08:03:37PM -0600, Dennis Zhou wrote:
> > > This happened also when I deleted everything from the filesystem and ran
> > > full balance.
> 
> Also were these both on fresh file systems so it seems reproducible for
> you?

Yes the filesystem was freshly created before the test.

No luck reproducing it, I tried to repeat the steps as before but the
timing must make a difference and the numbers always ended up as 0
(bytes) 0 (extents).

> > I'll report back if I continue having trouble reproing it.
> 
> I spent the day trying to repro against ext/dzhou-async-discard-v6
> without any luck... I've been running the following:
> 
> $ mkfs.btrfs -f /dev/nvme0n1
> $ mount -t btrfs -o discard=async /dev/nvme0n1 mnt
> $ cd mnt
> $ bash ../age_btrfs.sh .
> 
> where age_btrfs.sh is from [1].
> 
> If I delete arbitrary subvolumes, sync, and then run balance:
> $ btrfs balance start --full-balance .
> It all seems to resolve to 0 after some time. I haven't seen a negative
> case on either of my 2 boxes. I've also tried unmounting and then
> remounting, deleting and removing more free space items.
> 
> I'm still considering how this can happen. Possibly bad load of free
> space cache and then freeing of the block group? Because being off by
> just 1 and it not accumulating seems to be a real corner case here.
> 
> Adding asserts in btrfs_discard_update_discardable() might give us
> insight to which callsite is responsible for going below 0.

Yeah more asserts would be good.
