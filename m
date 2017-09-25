Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57473 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S935320AbdIYO6F (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Sep 2017 10:58:05 -0400
Date: Mon, 25 Sep 2017 16:56:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/3] btrfs: cleanup btrfs_init_new_device()
Message-ID: <20170925145631.GJ31640@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170925123104.16526-1-anand.jain@oracle.com>
 <20170925123104.16526-3-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170925123104.16526-3-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 25, 2017 at 08:31:03PM +0800, Anand Jain wrote:
> Moves btrfs_abort_transaction() to the error goto and renames
> error_trans to error_sysfs. This is a preparatory patch to
> remove the BUG_ON() in btrfs_init_new_device().

Please keep all transaction abort exactly at the place where they
happened and do not merge them to one. This pattern should be used
everwhere and is important when debugging because we can pinpoint the
line in the code from the syslog message and do not have to guess which
way it got to the merged call.

This makes the binary large, looks like a code duplication in the code
but for a good reason.
