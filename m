Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58601 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751367AbdC0RNR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 13:13:17 -0400
Date: Mon, 27 Mar 2017 19:12:28 +0200
From: David Sterba <dsterba@suse.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] Btrfs: set scrub page's io_error if failing to submit io
Message-ID: <20170327171227.GM4781@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1490399280-2624-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1490399280-2624-1-git-send-email-bo.li.liu@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 24, 2017 at 04:48:00PM -0700, Liu Bo wrote:
> Otherwise, we may later skip this page when repairing bad copy from
> good copy.

Can you please enhance the changelog? At least some more pointers what
and where it could go wrong if the value is not set properly, to get the
rough idea. Thanks.
