Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:58198
        "EHLO p3nlsmtpcp01-01.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751491AbdF0DLA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 26 Jun 2017 23:11:00 -0400
Date: Tue, 27 Jun 2017 08:39:48 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v4] btrfs-progs: btrfs-convert: Add larger device support
Message-ID: <20170627030948.GB2568@giis.co.in>
References: <20170603095745.GA4730@giis.co.in>
 <20170626124712.GH2866@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170626124712.GH2866@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > -	u32 free_inodes_count;
> > +	u64 first_data_block;
> > +	u64 block_count;
> > +	u64 inodes_count;
> > +	u64 free_inodes_count;
> 
> I've split this change from the patch as it does not logically belong to
> the same patch, altough the change is simple.

Okay sure, thanks. 

Cheers.
Lakshmipathi.G
