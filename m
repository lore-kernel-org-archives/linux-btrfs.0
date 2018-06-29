Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([91.121.86.59]:38380 "EHLO rin.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932395AbeF2HP1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Jun 2018 03:15:27 -0400
Date: Fri, 29 Jun 2018 12:09:54 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: So, does btrfs check lowmem take days? weeks?
Message-ID: <20180629120954.4bbcd174@natsu>
In-Reply-To: <20180629065903.xgwpvaa2vuiys75r@merlins.org>
References: <20180629042707.vrjwbytg6bxmrgjg@merlins.org>
        <6658a593-3b4a-f1ef-f550-2fb951b2517d@gmx.com>
        <20180629052825.tifg2aw7oy3qyyvw@merlins.org>
        <3b240898-a96d-77f6-efb9-f0af81ee0cd1@gmx.com>
        <20180629060657.qrtcxfcy22zkstfw@merlins.org>
        <e9264580-7853-fbfc-2c90-e28e8a45daf5@gmx.com>
        <20180629065903.xgwpvaa2vuiys75r@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 28 Jun 2018 23:59:03 -0700
Marc MERLIN <marc@merlins.org> wrote:

> I don't waste a week recreating the many btrfs send/receive relationships.

Consider not using send/receive, and switching to regular rsync instead.
Send/receive is very limiting and cumbersome, including because of what you
described. And it doesn't gain you much over an incremental rsync. As for
snapshots on the backup server, you can either automate making one as soon as a
backup has finished, or simply make them once/twice a day, during a period
when no backups are ongoing.

-- 
With respect,
Roman
