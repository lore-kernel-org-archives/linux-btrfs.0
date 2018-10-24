Return-Path: <SRS0=Pubh=NE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC613C46475
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 03:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7608B2075D
	for <linux-btrfs@archiver.kernel.org>; Wed, 24 Oct 2018 03:37:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7608B2075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=merlins.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbeJXMDk (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 24 Oct 2018 08:03:40 -0400
Received: from magic.merlins.org ([209.81.13.136]:46523 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725896AbeJXMDk (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Oct 2018 08:03:40 -0400
X-Greylist: delayed 1809 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2018 08:03:40 EDT
Received: from svh-gw.merlins.org ([173.11.111.145]:56436 helo=legolas.merlins.org)
        by mail1.merlins.org with esmtps 
        (Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.87 #1)
        id 1gF79i-0003SF-KS; Tue, 23 Oct 2018 17:36:17 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
        (envelope-from <marc@merlins.org>)
        id 1gF79h-0003nh-Kj; Tue, 23 Oct 2018 17:36:13 -0700
Date:   Tue, 23 Oct 2018 17:36:13 -0700
From:   Marc MERLIN <marc@merlins.org>
To:     linux-btrfs@vger.kernel.org
Message-ID: <20181024003613.q5bxmqm4hh5xbgmf@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sysadmin: BOFH
X-URL:  http://marc.merlins.org/
User-Agent: NeoMutt/20160916 (1.7.0)
X-SA-Exim-Connect-IP: 173.11.111.145
X-SA-Exim-Mail-From: marc@merlins.org
Subject: Have 15GB missing in btrfs filesystem.
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Normally when btrfs fi show will show lost space because 
your trees aren't balanced.
Balance usually reclaims that space, or most of it.
In this case, not so much.

kernel 4.17.6:

saruman:/mnt/btrfs_pool1# btrfs fi show .
Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
	Total devices 1 FS bytes used 186.89GiB
	devid    1 size 228.67GiB used 207.60GiB path /dev/mapper/pool1

Ok, I have 21GB between used by FS and used in block layer.

saruman:/mnt/btrfs_pool1# btrfs balance start -dusage=40 -v .
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=40
Done, had to relocate 1 out of 210 chunks
saruman:/mnt/btrfs_pool1# btrfs balance start -musage=60 -v .
Dumping filters: flags 0x6, state 0x0, force is off
  METADATA (flags 0x2): balancing, usage=60
  SYSTEM (flags 0x2): balancing, usage=60
Done, had to relocate 4 out of 209 chunks
saruman:/mnt/btrfs_pool1# btrfs fi show .
Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
	Total devices 1 FS bytes used 186.91GiB
	devid    1 size 228.67GiB used 205.60GiB path /dev/mapper/pool1

That didn't help much, delta is now 19GB

saruman:/mnt/btrfs_pool1# btrfs balance start -dusage=80 -v .
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=80
Done, had to relocate 8 out of 207 chunks
saruman:/mnt/btrfs_pool1# btrfs fi show .
Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
	Total devices 1 FS bytes used 187.03GiB
	devid    1 size 228.67GiB used 201.54GiB path /dev/mapper/pool1

Ok, now delta is 14GB

saruman:/mnt/btrfs_pool1# btrfs balance start -musage=80 -v .
Dumping filters: flags 0x6, state 0x0, force is off
  METADATA (flags 0x2): balancing, usage=80
  SYSTEM (flags 0x2): balancing, usage=80
Done, had to relocate 5 out of 202 chunks
saruman:/mnt/btrfs_pool1# btrfs fi show .
Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
	Total devices 1 FS bytes used 188.24GiB
	devid    1 size 228.67GiB used 203.54GiB path /dev/mapper/pool1

and it's back to 15GB :-/

How can I get 188.24 and 203.54 to converge further? Where is all that
space gone?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
