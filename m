Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48036 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1756160AbdGCOW0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 3 Jul 2017 10:22:26 -0400
Date: Mon, 3 Jul 2017 16:21:08 +0200
From: David Sterba <dsterba@suse.cz>
To: linux-btrfs@vger.kernel.org
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org
Subject: Temporary changes regarding btrfs branch in linux-next and
 development patches
Message-ID: <20170703142108.GZ2866@suse.cz>
Reply-To: dsterba@suse.cz
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

in order to allow merging new btrfs patches and also keep linux-next merging
sane [1], I'm going to freeze any changes to my k.org [2] branch for-next until
4.13-rc1 is released, expecting that the conflicting branches get merged as
well.

* k.org for-next will contain only the upcoming pull request
  (top commit 848c23b78fafdcd3270b06a30737f8dbd70c347f)
* k.org for-next-test will gather patches and patchsets from mailinglist as usual

[1] https://marc.info/?l=linux-next&m=149904517832129
[2] https://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git/
