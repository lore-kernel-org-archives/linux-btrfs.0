Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58383 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751516AbdINMne (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Sep 2017 08:43:34 -0400
Date: Thu, 14 Sep 2017 14:42:03 +0200
From: David Sterba <dsterba@suse.cz>
To: Naohiro Aota <naohiro.aota@wdc.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs: build: omit unnecessary -MD flag
Message-ID: <20170914124203.GT29043@suse.cz>
Reply-To: dsterba@suse.cz
References: <150538384653.24503.41288304442819820.stgit@naota.dhcp.fujisawa.hgst.com>
 <150538385685.24503.15875606860945494531.stgit@naota.dhcp.fujisawa.hgst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <150538385685.24503.15875606860945494531.stgit@naota.dhcp.fujisawa.hgst.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 14, 2017 at 07:10:56PM +0900, Naohiro Aota wrote:
> According to gcc(1), "-MD is equivalent to -M -MF file, except that -E is not
> implied." Since the rule in the Makefile is just generating dependency file
> and not building object file, it is no use to have "-MD" here. Also, it's
> overridden and conflicting with the following "-MM" flag. I guess we can drop
> it.
> 
> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>

Applied, thanks.
