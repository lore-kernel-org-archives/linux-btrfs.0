Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47787 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbbABPJU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Jan 2015 10:09:20 -0500
Date: Fri, 2 Jan 2015 16:09:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4] btrfs-progs: fix page align issue for lzo compress in
 restore
Message-ID: <20150102150919.GA6114@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140922134115.GP9715@twin.jikos.cz>
 <1411461294-24093-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <1929724.Hf7kupaGA7@fb07-iapwap2>
 <20141014093234.GP22943@twin.jikos.cz>
 <1417057358.14696.7.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417057358.14696.7.camel@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 27, 2014 at 11:02:38AM +0800, Gui Hecheng wrote:
> I note that this patch is not yet in the latest integration, how's the
> fix going?

The patch was still buggy, a fix will land in 3.18.1
