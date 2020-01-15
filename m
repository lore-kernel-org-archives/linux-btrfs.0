Return-Path: <SRS0=+Z9o=3E=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D423AC33CB2
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jan 2020 13:45:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B37B0207FF
	for <linux-btrfs@archiver.kernel.org>; Wed, 15 Jan 2020 13:45:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgAONpi (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 15 Jan 2020 08:45:38 -0500
Received: from snd00010.auone-net.jp ([111.86.247.10]:51296 "EHLO
        dmta0009.auone-net.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726071AbgAONpi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Jan 2020 08:45:38 -0500
Received: from ppp.dion.ne.jp by dmta0009.auone-net.jp with ESMTP
          id <20200115134536820.LBFZ.46476.ppp.dion.ne.jp@dmta0009.auone-net.jp>;
          Wed, 15 Jan 2020 22:45:36 +0900
Date:   Wed, 15 Jan 2020 22:45:36 +0900
From:   Kusanagi Kouichi <slash@ac.auone-net.jp>
To:     dsterba@suse.cz
Cc:     linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Implement lazytime
References: <20200114085325045.JFBE.12086.ppp.dion.ne.jp@dmta0008.auone-net.jp>
 <20200114212107.GM3929@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114212107.GM3929@twin.jikos.cz>
Message-Id: <20200115134536820.LBFZ.46476.ppp.dion.ne.jp@dmta0009.auone-net.jp>
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 2020-01-14 22:21:07 +0100, David Sterba wrote:
> On Tue, Jan 14, 2020 at 05:53:24PM +0900, Kusanagi Kouichi wrote:
> > I tested with xfstests and lazytime didn't cause any new failures.
> 
> The changelog should describe what the patch does (the 'why' part too,
> but this is obvious from the subject in this case). That fstests pass
> without new failures is nice but there should be a specific test for
> that or instructions in the changelog how to test.

To test lazytime, I set the following variables:
TEST_FS_MOUNT_OPTS="-o lazytime,space_cache=v2"
MOUNT_OPTIONS="-o lazytime,space_cache=v2"
