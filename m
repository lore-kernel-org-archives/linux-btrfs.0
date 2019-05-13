Return-Path: <SRS0=eL0R=TN=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31D65C04AB1
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 May 2019 03:40:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02CCA208E3
	for <linux-btrfs@archiver.kernel.org>; Mon, 13 May 2019 03:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557718836;
	bh=DryeN/LU1PfcWpt4sPjFbqOwGkcLVE14phukOlar410=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=Hi1iCI0LFQBDN0CJukUsaTHhjUKG5LhLa4Q9P4jyDDxpyBLI0VuWcoEU2t1inUO1D
	 t8H5M6f7KHjJii9YjKUniYFseUrdDwneNAw+WpC8Jx9vBWSAiPku9noeSbhEaRGnZB
	 m8/SOuDtJqxWvAyX+L42QmshV33D1Kka+Lsw8ouA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfEMDkU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 12 May 2019 23:40:20 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:51421 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727202AbfEMDkU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 12 May 2019 23:40:20 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 072F7221AD;
        Sun, 12 May 2019 23:40:19 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 12 May 2019 23:40:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=2FlEJdf2fi3fJ5B4N
        RVr7xTzZV11Nurruym7Rqoj6sE=; b=EQlQ7R49I/nSEGF9TKzS4iTWhGsFwsJN8
        oNkPN7E7hed7HHnSRABYN17LKtv9T1oEFNtTJUJyovG8BaslPSK8Hsk/2KaYGwdE
        vORNsRanDIEU3+5LMR1vpGl10hkFJZPkRTqZAqnkBuwet2G14PTQqLm6KYUMfzJq
        xJj5XVqkSi3htu4E7B8CkvGO60GGId9VGMrt3cgy4rYmpSzLgmt9INvvQdNXSJA2
        rZljskz4V+7JRCazGKGd+WkpVnB50iSyeKqZomDsSpl07xzQKaYZjgLjbCA+/9wd
        jKfkLJj61/G4SN9rEh+HQHFGXx30zIIRCP94M6TZHc50pUXLpY36w==
X-ME-Sender: <xms:IufYXLkSS02FbOSvuPZ74YpQiEmkZuswEdDUNLzpRyplKWCCHgE2DA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrleefgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepfdfvohgsihhnucev
    rdcujfgrrhguihhnghdfuceothhosghinheskhgvrhhnvghlrdhorhhgqeenucfkphepud
    dvgedrudeiledrudeirddukeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehtohgsihhn
    sehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:IufYXFuqtnb2NJbkXGZXJHBWpwKap5ZwyymrsUu1taqUiV2uIFbzww>
    <xmx:IufYXOnLSanRFX-UVU8l1UxAawWIrpeCyTy6Yh01BvfkCuKgAoBNQw>
    <xmx:IufYXAsyPthflq6i7tgOqHQhmVU-1DyBVSB18Kyy_OPVZCLkFsOELg>
    <xmx:IufYXH2EjAK7p8I9_CLuJ17YhXiHJHhZ3HCMIbbkG4fGcbxfmf128A>
Received: from eros.localdomain (124-169-16-185.dyn.iinet.net.au [124.169.16.185])
        by mail.messagingengine.com (Postfix) with ESMTPA id 285B08005C;
        Sun, 12 May 2019 23:40:14 -0400 (EDT)
From:   "Tobin C. Harding" <tobin@kernel.org>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Cc:     "Tobin C. Harding" <tobin@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] Fix kobject error path memleaks 
Date:   Mon, 13 May 2019 13:39:10 +1000
Message-Id: <20190513033912.3436-1-tobin@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi,

Is it ok to send patches during the merge window?  Applies on top of
Linus' mainline tag: v5.1, happy to rebase if there are conflicts.

While auditing kobject_init_and_add() calls throughout the kernel it was
found that btrfs potentially has a couple of memleaks in the error path
code for kobject_init_and_add().

Failing calls to kobject_init_and_add() should be followed by a call to
kobject_put() since kobject_init_and_add() always calls kobject_init().

Of note, adding kobject_put() causes the release method to be called if
kobject_init_and_add() fails.  For patch #1 this means we don't have to
manually free the space_info or call percpu_counter_destroy() since
these are both done by the release method.  In the second patch, I
believe the added call to kobject_put() fits in with the fs_devices
lifecycle assumptions of open_ctree() but please could you review since
I am new to this code.

CC'ing the kobject maintainers/reviewers also.

Thanks,
Tobin.


Tobin C. Harding (2):
  fs: btrfs: Fix error path kobject memory leak
  fs: btrfs: Don't leak memory when failing add fsid

 fs/btrfs/extent-tree.c | 3 +--
 fs/btrfs/sysfs.c       | 7 ++++++-
 2 files changed, 7 insertions(+), 3 deletions(-)

-- 
2.21.0

