Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47826 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726611AbeHWLEY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Aug 2018 07:04:24 -0400
Received: from relay1.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id B2D1EADE8
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Aug 2018 07:36:05 +0000 (UTC)
Subject: Re: [PATCH] btrfs-progs: dump-tree: Introduce --breadth-first option
To: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180823073107.17016-1-wqu@suse.com>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <2d6c65be-6b54-95d7-29a7-fa24f98989fb@suse.com>
Date: Thu, 23 Aug 2018 10:36:03 +0300
MIME-Version: 1.0
In-Reply-To: <20180823073107.17016-1-wqu@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 23.08.2018 10:31, Qu Wenruo wrote:
> Introduce --breadth-first option to do breadth-first tree dump.
> This is especially handy to inspect high level trees, e.g. comparing
> tree reloc tree with its source tree.

Will it make sense instead of exposing another option to just have a
heuristics check that will switch to the BFS if the tree is higher than,
say, 2 levels?
