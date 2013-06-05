Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from longford.logfs.org ([213.229.74.203]:59387 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3FEDiq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Jun 2013 23:38:46 -0400
Date: Tue, 4 Jun 2013 22:09:39 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Arne Jansen <sensille@gmx.net>
Cc: Chris Mason <clmason@fusionio.com>, Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/2] introduce list_for_each_entry_del
Message-ID: <20130605020939.GC27240@logfs.org>
References: <1370280485-10047-1-git-send-email-joern@logfs.org>
 <20130603204930.GA28299@infradead.org>
 <20130603193647.GB10200@logfs.org>
 <20130603195555.GC10200@logfs.org>
 <20130604144856.GA12302@infradead.org>
 <20130604145322.4088.78915@localhost.localdomain>
 <51AE4969.8050709@gmx.net>
 <20130604184435.GA23436@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20130604184435.GA23436@logfs.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 4 June 2013 14:44:35 -0400, Jörn Engel wrote:
> 
> Or while_list_drain?

Not sure if the silence is approval or lack of interest, but a new set
of patches is posted.  By playing around with the implementation a
bit, I have actually found a variant that makes the object code
shrink.  Not one variant gave same-size object code.  There's compiler
optimization for you.

Jörn

--
Money can buy bandwidth, but latency is forever.
-- John R. Mashey
