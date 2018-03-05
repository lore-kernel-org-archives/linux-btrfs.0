Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60219 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752063AbeCEVSn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 5 Mar 2018 16:18:43 -0500
Date: Mon, 5 Mar 2018 22:16:23 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: drop nonvaring variable, instead define it
Message-ID: <20180305211623.GE5942@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180226084814.7229-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180226084814.7229-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 26, 2018 at 04:48:14PM +0800, Anand Jain wrote:
> btrfs_defrag_leaves() has min_trans = 0 which doesn't vary.
> Defining it makes sense.

Defining the oldest transaction makes sense and it can be used in more
calls to btrfs_search_forward, please update the patch.
