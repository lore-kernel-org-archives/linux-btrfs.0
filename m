Return-Path: <SRS0=gdyl=Y4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6B2CA9EA0
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Nov 2019 12:03:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29BD0217F4
	for <linux-btrfs@archiver.kernel.org>; Mon,  4 Nov 2019 12:03:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727838AbfKDMD1 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 4 Nov 2019 07:03:27 -0500
Received: from submit.uniweb.no ([91.207.158.45]:57413 "EHLO submit.uniweb.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727322AbfKDMD1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Nov 2019 07:03:27 -0500
X-Greylist: delayed 1683 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Nov 2019 07:03:26 EST
Received: from [91.207.158.168] (helo=mail.uniweb.no)
        by submit.uniweb.no with esmtpa (Exim 4.90_1)
        (envelope-from <odin@digitalgarden.no>)
        id 1iRadj-00029r-Kr
        for linux-btrfs@vger.kernel.org; Mon, 04 Nov 2019 12:35:19 +0100
Date:   Mon, 4 Nov 2019 12:35:19 +0100
From:   Odin Hultgren van der Horst <odin@digitalgarden.no>
To:     linux-btrfs@vger.kernel.org
Subject: Extent to files
Message-ID: <20191104113519.htdigcg6lzbes6v7@T580.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

I did a ioctl(FICLONE) IOCTL-FICLONERANGE(2) at some point later I want to be
able to check if the new file still shares all its physical storage with just
knowing the name of the new file.

I found some people suggesting to compare the files extents.

But the implementation I looked at knew both files used in the comparison,
so I was wondering if there a way to get all files that references a extent
in user space?

In reality I want a count off clones/(identical files) to a given file
in user space.
