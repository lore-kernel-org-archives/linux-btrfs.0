Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932593AbcECRcF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 May 2016 13:32:05 -0400
Date: Tue, 3 May 2016 19:31:48 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz,
        yauhen.kharuzhy@zavadatar.com
Subject: Re: [PATCH] btrfs: s_bdev is not null after missing replace
Message-ID: <20160503173148.GL29353@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1460629450-2271-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1460629450-2271-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 14, 2016 at 06:24:10PM +0800, Anand Jain wrote:
> Yauhen reported in the ML that s_bdev is null at mount, and
> s_bdev gets updated to some device when missing device is
> replaced, as because bdev is null for missing device, things
> gets matched up. Fix this by checking if s_bdev is set. I
> didn't want to completely remove updating s_bdev because
> the future multi device support at vfs layer may need it.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Reported-by: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>

Do you have a testcase for that? As there are more patches touching the
device pointers I'd rather see some test coverage. Thanks.
