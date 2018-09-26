Return-Path: <SRS0=dcfB=MI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97993C43382
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 10:31:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44E2120843
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Sep 2018 10:31:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 44E2120843
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbeIZQn0 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Sep 2018 12:43:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:37036 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727003AbeIZQn0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Sep 2018 12:43:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8EE00AF71
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Sep 2018 10:31:07 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id D63A0DAE2F; Wed, 26 Sep 2018 12:31:06 +0200 (CEST)
Date:   Wed, 26 Sep 2018 12:31:06 +0200
From:   David Sterba <dsterba@suse.cz>
To:     linux-btrfs@vger.kernel.org
Subject: Archives of linux-btrfs at lore.kernel.org
Message-ID: <20180926103106.GG3255@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

the initial upload of mail archives has been published at

  https://lore.kernel.org/linux-btrfs/

thanks to the kernel.org team.

The archive contents are from my mailboxes and span the range years 2008-2018,
also containing mails from the original oracle.com btrfs-devel list (scraped
from GMANE).  All new mails starting 25.9.2018 become part of the archive
automatically.

It's quite possible that there are still missing mails and there's a way to add
them. The lists of message ids in the inial upload can be found at

  https://mirrors.edge.kernel.org/pub/linux/kernel/people/kdave/linux-btrfs.mbox/linux-btrfs-known-ids.txt

the mails at

  https://mirrors.edge.kernel.org/pub/linux/kernel/people/kdave/linux-btrfs.mbox/linux-btrfs-export.tar

The steps to create the sanitized mailboxes is documented at
https://korg.wiki.kernel.org/userdoc/lore together with steps how to merge two
existing archives, using the files above.

If you happen to find mails that are missing, please let me know so we can
complete the archives.

Thanks.
