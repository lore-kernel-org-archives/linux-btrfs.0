Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38784 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389593AbeHAQ1O (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Aug 2018 12:27:14 -0400
Date: Wed, 1 Aug 2018 16:41:07 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 4/4] btrfs: add helper btrfs_num_devices() to deduce
 num_devices
Message-ID: <20180801144107.GI3218@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180726065334.30594-1-anand.jain@oracle.com>
 <20180726065334.30594-5-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180726065334.30594-5-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 26, 2018 at 02:53:34PM +0800, Anand Jain wrote:
> When the replace is running the fs_devices::num_devices also includes
> the replace device, however in some operations like device delete and
> balance it needs the actual num_devices without the repalce devices, so
> now the function btrfs_num_devices() just provides that.

The part how concurrent balance and dev-replace can be active at the
same time is missing. As this is not obvious, it's desired to have that
in the changelog.

If there are questions and comments in past patchset revisions, that's a
good material for changelogs and when you send an update you can enhance
the changelogs. I do simple fixups or additions but when you send a new
revision it the right time to save time on both sides.
