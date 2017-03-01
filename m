Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56107 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752219AbdCAQ2g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Mar 2017 11:28:36 -0500
Date: Wed, 1 Mar 2017 17:27:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 10/12] btrfs-progs: fsck-test: Add new test case for
 file extent false alerts
Message-ID: <20170301162733.GH4662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170221083438.25719-1-quwenruo@cn.fujitsu.com>
 <20170221083438.25719-11-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170221083438.25719-11-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 21, 2017 at 04:34:36PM +0800, Qu Wenruo wrote:
> +check_global_prereq xfs_io

> +	run_check xfs_io -c "pwrite 0 64K" "$TEST_MNT/file"

> +	run_check xfs_io -f -c "pwrite 0 1K" "$TEST_MNT/file"

I've converted this to dd as we don't want to depend on xfsprogs
installed for the tests.
