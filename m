Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:58016 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737Ab2INN1B (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 09:27:01 -0400
Date: Fri, 14 Sep 2012 15:26:54 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Josef Bacik <jbacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 2/5] Btrfs: fix trans block rsv regression
Message-ID: <20120914132654.GK17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1347613087-3489-1-git-send-email-bo.li.liu@oracle.com>
 <1347613087-3489-2-git-send-email-bo.li.liu@oracle.com>
 <20120914124159.GI12994@localhost.localdomain>
 <50532AB0.2020701@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50532AB0.2020701@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 09:01:36PM +0800, Liu Bo wrote:
> Fine, please run xfstests 068 till it hits a BUG_ON inside either btrfs_delete_delayed_dir_index or
> btrfs_insert_delayed_dir_index.

068 is the freezer test, we've seen enough issues in the freezing area
recently, I'm curious if you were able to reproduce with a non-freezing
tests.

It's quite possible that this may be a race condition and the freezer
just supplies the right delays and widens the race window.
