Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38000 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730234AbeGROOM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 18 Jul 2018 10:14:12 -0400
Date: Wed, 18 Jul 2018 15:36:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/19] qgroup unused parameter cleanup
Message-ID: <20180718133607.GA26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180718064542.2730-1-lufq.fnst@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 18, 2018 at 02:45:23PM +0800, Lu Fengqi wrote:
> The transaction handler can provide fs_info, so we can fetch fs_info or
> quota_root(indirectly) from trans. Just remove the redundant parameter
> from qgroup functions.

Added to misc-next now, thanks.
