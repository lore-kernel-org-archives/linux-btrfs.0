Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53492 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751002AbeEVKln (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 May 2018 06:41:43 -0400
Date: Tue, 22 May 2018 12:38:59 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: drop uuid_mutex in btrfs_free_extra_devids()
Message-ID: <20180522103859.GB6649@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180522092929.12014-1-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180522092929.12014-1-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 22, 2018 at 05:29:29PM +0800, Anand Jain wrote:
> btrfs_free_extra_devids() frees the orphan fsid::devid with in
> btrfs_fs_devices::devices, so we dont need uuid_mutex, instead hold the
> btrfs_fs_devices::device_list_mutex.

This still lacks the reason why, the text merely repeats what the code
change does.
