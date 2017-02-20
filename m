Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39315 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752712AbdBTRI3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Feb 2017 12:08:29 -0500
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9909DABD9
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Feb 2017 17:08:26 +0000 (UTC)
To: linux-btrfs@vger.kernel.org
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Why is btrfs_run_delayed_refs() run multiple times
Message-ID: <f1156c2d-20d1-eb7c-6d48-207d22a34512@suse.de>
Date: Mon, 20 Feb 2017 11:08:23 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Why do we call btrfs_run_delayed_refs multiple times in a function? Some
of the examples are:

btrfs_commit_transaction()
commit_cowonly_roots()

Is it because one call can generate more delayed refs and hence we need
to run them again? Under what scenarios is this possible?

-- 
Goldwyn
