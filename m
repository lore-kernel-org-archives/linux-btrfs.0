Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753323AbcBOOvK (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 09:51:10 -0500
Date: Mon, 15 Feb 2016 15:51:06 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 06/13] btrfs: create helper function
 __check_raid_min_devices()
Message-ID: <20160215145106.GL4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1455328900-1476-1-git-send-email-anand.jain@oracle.com>
 <1455328900-1476-7-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1455328900-1476-7-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 13, 2016 at 10:01:33AM +0800, Anand Jain wrote:
> move a section of btrfs_rm_device() code to check for min number of the
> devices into the function __check_raid_min_devices()

But this also changes the semantics a bit. In context of device remove
we check if there are going to be enough devices after removal, while
the new helper __check_raid_min_devices should verify that a given
number of devices is OK.

In a pseudo code:

__check_raid_min_devices(fs_info, num_devices) {
	/* check the device constraints */
}

btrfs_rm_device() {
	num_devices = <read number of devices>;

	if (!__check_raid_min_devices(num_devices - 1))
		goto error;
}

As there's only one user of the __check_raid_min_devices function, this
would not break bisection etc, but I'm going to clean it up in followup
patches. There are more changes, I'll send it to the mailing list when
done.
