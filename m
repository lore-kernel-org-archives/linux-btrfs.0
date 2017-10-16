Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49525 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753567AbdJPPRZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 16 Oct 2017 11:17:25 -0400
Date: Mon, 16 Oct 2017 17:15:38 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz, anand.jain@oracle.com
Subject: Re: [PATCH v3 0/4] btrfs: cleanup mount path
Message-ID: <20171016151538.GV3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <4786f7cc-adc7-1b99-5abf-d068acee56c2@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4786f7cc-adc7-1b99-5abf-d068acee56c2@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 25, 2017 at 04:26:30PM +0900, Misono, Tomohiro wrote:
> Summary:
> Cleanup mount path by avoiding calling btrfs_mount() twice.
> No functional change. See below for longer explanation.
> 
> Changelog:
> v3:
>   Reorganized patches again into four and added comments to the source.
>   Each patch can be applied and compiled while maintaining functionality.
>   The first one is the preparation and the second one is the main part.
>   The last two are small cleanups.

I'm conditionally adding this series to for-next for testing.
