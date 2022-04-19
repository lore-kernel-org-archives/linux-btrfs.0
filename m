Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42C79C433F5
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Apr 2022 16:06:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244957AbiDSQI5 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 12:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354462AbiDSQIq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Apr 2022 12:08:46 -0400
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAB23B018
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Apr 2022 09:05:57 -0700 (PDT)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id F236F7CF;
        Tue, 19 Apr 2022 16:05:52 +0000 (UTC)
Date:   Tue, 19 Apr 2022 21:05:51 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     Gabriel Niebler <gniebler@suse.com>
Cc:     linux-btrfs@vger.kernel.org, dsterba@suse.com
Subject: Re: [PATCH v5] btrfs: Turn delayed_nodes_tree into an XArray
Message-ID: <20220419210551.65db356b@nvm>
In-Reply-To: <20220419155721.6702-1-gniebler@suse.com>
References: <20220419155721.6702-1-gniebler@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, 19 Apr 2022 17:57:21 +0200
Gabriel Niebler <gniebler@suse.com> wrote:

> -	btrfs_init_delayed_node(node, root, ino);
> +        do {

The "do" line appears one character off to the right for me, and upon
examination that's because it uses spaces for indentation instead of TABs like
all other lines. Did not check if this is the only place.

There is "checkpatch.pl" which would catch issues like this:
https://www.kernel.org/doc/html/latest/dev-tools/checkpatch.html

-- 
With respect,
Roman
