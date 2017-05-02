Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:39154 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750744AbdEBPGI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 11:06:08 -0400
Date: Tue, 2 May 2017 17:06:01 +0200
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <Lakshmipathi.G@giis.co.in>
Cc: quwenruo@cn.fujitsu.com, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: btrfs-convert: Add larger device support
Message-ID: <20170502150601.GK23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170427100534.GA10404@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170427100534.GA10404@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 27, 2017 at 03:35:34PM +0530, Lakshmipathi.G wrote:
> Bug: Fail to convert 22TB EXT4 to BTRFS
> https://bugzilla.kernel.org/show_bug.cgi?id=194795

Thanks for working on the bug, the proposed fix looks good to me judging
by the use of extended API. This would need a test though. I'm trying
this on a sparse file, 3TB occupies 50G and is slow to create.
Conversion works and hasn't finished yet, so this is not suitable for
tests run by default.

Please write a more detailed changelog, a reference to bugzilla is not
really sufficient.
