Return-Path: <SRS0=3TJ0=NH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E990C46475
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 15:52:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CEB82085B
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 15:52:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9CEB82085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=wantstofly.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbeJ1AeU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 27 Oct 2018 20:34:20 -0400
Received: from hmm.wantstofly.org ([138.201.34.84]:39732 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728501AbeJ1AeU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Oct 2018 20:34:20 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Oct 2018 20:34:20 EDT
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id A8E657F3D7; Sat, 27 Oct 2018 18:45:55 +0300 (EEST)
Date:   Sat, 27 Oct 2018 18:45:55 +0300
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     linux-btrfs@vger.kernel.org
Subject: FS_IOC_FIEMAP fe_physical discrepancies on btrfs
Message-ID: <20181027154555.GH16768@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hello!

FS_IOC_FIEMAP on btrfs seems to be returning fe_physical values that
don't always correspond to the actual on-disk data locations.  For some
files the values match, but e.g. for this file:

# filefrag -v foo
Filesystem type is: 9123683e
File size of foo is 4096 (1 block of 4096 bytes)
 ext:     logical_offset:        physical_offset: length:   expected: flags:
   0:        0..       0:    5774454..   5774454:      1:             last,eof
foo: 1 extent found
#

The file data is actually on disk not in block 5774454 (0x581c76), but
in block 6038646 (0x5c2476), an offset of +0x40800.  Is this expected
behavior?  Googling didn't turn up much, apologies if this is an FAQ. :(

(This is on 4.18.16-200.fc28.x86_64, the current Fedora 28 kernel.)


Thanks,
Lennert
