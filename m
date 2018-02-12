Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56208 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751385AbeBLQ5h (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Feb 2018 11:57:37 -0500
Date: Mon, 12 Feb 2018 17:55:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: fix extent_buffer_uptodate() return
Message-ID: <20180212165519.GJ3003@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180212153456.19358-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180212153456.19358-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 12, 2018 at 11:34:56PM +0800, Anand Jain wrote:
> extent_buffer_uptodate() returns from test_bit() which is of
> type bool, so update extent_buffer_uptodate() to it.

The return value of test_bit differes by architecture, there are several
that return int. You probably refer to x86 that uses some trickery to
optimize for constants and that returns bool. While we can add more
int/bool, I don't think it's wrong to have int here so I don't see what
this patch fixes.

In this particular case, extent_buffer_uptodate is a trivial wrapper
around test_bit so it would be better to make it a static inline. This
would remove the call indirection and reduce size of the code.
