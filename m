Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47282 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550AbcDEIqg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Apr 2016 04:46:36 -0400
Date: Tue, 5 Apr 2016 10:43:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix re-declared get_device_info()
Message-ID: <20160405084303.GE3412@suse.cz>
Reply-To: dsterba@suse.cz
References: <1459841761-491-1-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1459841761-491-1-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 05, 2016 at 03:36:01PM +0800, Anand Jain wrote:
> The other get_device_info() is in the same file, 4 lines above.
> 
> Signed-off-by: Anand Jain <anand.jain@oracle.com>

Applied, thanks.
