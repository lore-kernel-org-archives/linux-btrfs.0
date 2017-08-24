Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50398 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752071AbdHXRi7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 24 Aug 2017 13:38:59 -0400
Date: Thu, 24 Aug 2017 19:37:34 +0200
From: David Sterba <dsterba@suse.cz>
To: "Misono, Tomohiro" <misono.tomohiro@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: doc: fix btrfs-inspect-internal rootid doc
Message-ID: <20170824173734.GI2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <453da244-de65-e58b-ef28-f6dbff093052@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <453da244-de65-e58b-ef28-f6dbff093052@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 24, 2017 at 04:39:53PM +0900, Misono, Tomohiro wrote:
> "btrfs inspect-internal rootid <path>" rejects a file to be specified in 
> the implementation.
> Therefore change "file or directory" to "directory" in the doc.

Is there a reason why a file should not be accepted? The ioctl supports
that just fine.
