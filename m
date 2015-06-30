Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37920 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbbF3Qmg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Jun 2015 12:42:36 -0400
Date: Tue, 30 Jun 2015 18:42:34 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: Add repair function for
 I_ERR_FILE_WRONG_NBYTES.
Message-ID: <20150630164234.GJ726@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1434685760-2013-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1434685760-2013-2-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1434685760-2013-2-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 19, 2015 at 11:49:20AM +0800, Qu Wenruo wrote:
> Some unknown kernel bug makes inode nbytes modification out of sync with
> file extent update.
> 
> But it's quite easy to fix in btrfs-progs anyway.
> 
> So just fix it by adding a new function repair_inode_nbytes by using the
> found_size in inode_record.

Please provide a test, either a crafted image or extend the
corrupt-block utility to corrupt the nbytes value on the fly.
