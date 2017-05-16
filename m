Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54991 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751483AbdEPOOi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 10:14:38 -0400
Date: Tue, 16 May 2017 16:13:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, rgoldwyn@suse.de
Subject: Re: [RFC PATCH v3.1 1/6] btrfs: qgroup: Add quick exit for non-fs
 extents
Message-ID: <20170516141340.GD4065@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170512033046.31981-1-quwenruo@cn.fujitsu.com>
 <20170512033046.31981-2-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170512033046.31981-2-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 12, 2017 at 11:30:41AM +0800, Qu Wenruo wrote:
> For btrfs_qgroup_account_extent(), modify make it exit quicker for
> non-fs extents.

A short explanation why this is ok would be desired here.
