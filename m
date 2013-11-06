Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43437 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754602Ab3KFRyM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 12:54:12 -0500
Date: Wed, 6 Nov 2013 18:54:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3] xfstests: add regression test for running btrfs
 balance and defrag concurrently
Message-ID: <20131106175406.GB16662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1383212062-30153-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1383212062-30153-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Oct 31, 2013 at 05:34:22PM +0800, Liu Bo wrote:
> The test aims to trigger snapshot-aware defrag path in write endio by
> running balance, which is not expected and leads to a crash.
> 
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Reviewed-by: David Sterba <dsterba@suse.cz>
