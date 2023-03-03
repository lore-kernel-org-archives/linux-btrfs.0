Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1B37C7EE2D
	for <linux-btrfs@archiver.kernel.org>; Fri,  3 Mar 2023 16:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjCCQ0F (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 3 Mar 2023 11:26:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbjCCQ0E (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 3 Mar 2023 11:26:04 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4651F1A95B
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Mar 2023 08:26:03 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 046FF1F381
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Mar 2023 16:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1677860762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=gHQoS5mYPcWbTUcTwMzb8ay0oDfKuKoNvLCR3wupwuM=;
        b=PLUZmKWKlD8RApRYgx4xdzjTeQH0RkeqGaUvFGQBknr5GoVZtHQPLLHG3WDbeMm1Os73fW
        b+FkpzWHL0Al5THi0zR4BzJQUghFOKZAntnDWQuJJuFI3cnMnvcEp8BN1ySbXwSUpI1VT+
        wT5HBNNpJajBAWRNi0qe1r2eCiJMvUU=
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id EDADE2C141
        for <linux-btrfs@vger.kernel.org>; Fri,  3 Mar 2023 16:26:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 43B62DA7A3; Fri,  3 Mar 2023 17:20:02 +0100 (CET)
From:   David Sterba <dsterba@suse.com>
To:     linux-btrfs@vger.kernel.org
Subject: Btrfs progs release 6.2.1
Date:   Fri,  3 Mar 2023 17:20:02 +0100
Message-Id: <20230303162002.24285-1-dsterba@suse.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

btrfs-progs version 6.2.1 have been released. This is a bugfix release.

Besides changes in git, the generated tarball has been fixed so it does not
require autogen.sh due to moved config.h. The generated manual pages haven't
been in the tarball due to a bug in release script since the sources switched
to RST, now added back.

Changelog:
   * fix build with crypto libraries
   * CI images updated, build tests extended

Tarballs: https://www.kernel.org/pub/linux/kernel/people/kdave/btrfs-progs/
Git: git://git.kernel.org/pub/scm/linux/kernel/git/kdave/btrfs-progs.git
