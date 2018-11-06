Return-Path: <SRS0=BJi/=NR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5BF5C32789
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 13:06:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87BDB2083D
	for <linux-btrfs@archiver.kernel.org>; Tue,  6 Nov 2018 13:06:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87BDB2083D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387884AbeKFWbz (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 6 Nov 2018 17:31:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:52544 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729272AbeKFWby (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 6 Nov 2018 17:31:54 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id C1A47B658;
        Tue,  6 Nov 2018 13:06:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id AA2CEDA8C8; Tue,  6 Nov 2018 14:06:31 +0100 (CET)
Date:   Tue, 6 Nov 2018 14:06:30 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Omar Sandoval <osandov@osandov.com>, fstests@vger.kernel.org,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/7] fstests: test Btrfs swapfile support
Message-ID: <20181106130630.GA24115@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Eryu Guan <guaneryu@gmail.com>,
        Omar Sandoval <osandov@osandov.com>, fstests@vger.kernel.org,
        kernel-team@fb.com, linux-btrfs@vger.kernel.org
References: <cover.1541193856.git.osandov@fb.com>
 <20181104160931.GE12788@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181104160931.GE12788@desktop>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Nov 05, 2018 at 12:09:31AM +0800, Eryu Guan wrote:
> On Fri, Nov 02, 2018 at 02:29:35PM -0700, Omar Sandoval wrote:
> > From: Omar Sandoval <osandov@fb.com>
> > 
> > This series fixes a couple of generic swapfile tests and adds some
> > Btrfs-specific swapfile tests. Btrfs swapfile support is scheduled for
> > 4.21 [1].
> > 
> > 1: https://www.spinics.net/lists/linux-btrfs/msg83454.html
> > 
> > Thanks!
> 
> Thanks for the fixes and new tests!
> 
> > 
> > Omar Sandoval (7):
> >   generic/{472,496,497}: fix $seeqres typo
> >   generic/{472,496}: fix swap file creation on Btrfs
> 
> I've merged above two patches, they're two obvious bug fixes.
> 
> >   btrfs: test swap file activation restrictions
> >   btrfs: test invalid operations on a swap file
> >   btrfs: test swap files on multiple devices
> >   btrfs: test device add/remove/replace with an active swap file
> >   btrfs: test balance and resize with an active swap file
> 
> These tests look fine to me, but it'd be really great if btrfs folks
> could help review above tests and provide Reviewed-by tags.

All look good to me,

Reviewed-by: David Sterba <dsterba@suse.com>

A few nits I saw:

- the command names should not be shortened, ie. 'btrfs subvolume
  snapshot' instead of 'btrfs subvol snap'
- the test description (eg. 3/7 and 4/7) could mention which case is
  tested, eg. swapfile with compression or COW or snapshot
- 4/7 has typo 'nowcow' in a comment
