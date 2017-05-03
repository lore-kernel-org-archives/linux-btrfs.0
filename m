Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from p3nlsmtpcp01-01.prod.phx3.secureserver.net ([184.168.200.138]:58590
        "EHLO p3nlsmtpcp01-01.prod.phx3.secureserver.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750955AbdECQjb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 3 May 2017 12:39:31 -0400
Date: Wed, 3 May 2017 22:08:19 +0530
From: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
To: dsterba@suse.cz, quwenruo@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: btrfs-convert: Add larger device support
Message-ID: <20170503163819.GA10030@giis.co.in>
References: <20170427100534.GA10404@giis.co.in>
 <20170502150601.GK23260@twin.jikos.cz>
 <20170502153556.GM23260@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170502153556.GM23260@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> file is ~160MB. This sounds much better. So please write a test, using
> something like
> 
> truncate -s3T image
> mkfs.ext4 image
> mount && write some data
> convert && rollback
> 
> Thanks.  Later we might need to add some mkfs.ext4 option coverage.
Sure, will send the above test script in upcoming days, then look
into mkfs.ext4 options. thanks.

Cheers.
Lakshmipathi.G
