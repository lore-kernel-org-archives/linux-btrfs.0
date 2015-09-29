Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934243AbbI2LlZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Sep 2015 07:41:25 -0400
Date: Tue, 29 Sep 2015 13:40:24 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Juan Francisco Cantero Hurtado <iam@juanfra.info>,
        linux-btrfs@vger.kernel.org
Subject: Re: mkfs.btrfs(8) --data outdated?
Message-ID: <20150929114023.GW11442@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <mu9jpv$l25$1@ger.gmane.org>
 <56089651.6080803@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56089651.6080803@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 28, 2015 at 09:22:25AM +0800, Qu Wenruo wrote:
> We're planning to add support for -d dup on single disk case, and will 
> update man page at that time.

Is dup for data possible? IIRC long time ago Chris mentioned that this
does not work due to some offsets that would cause corruption. I was not
able to find the reference though.
