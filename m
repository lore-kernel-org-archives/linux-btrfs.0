Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41534 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454AbaG3Pyd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 11:54:33 -0400
Date: Wed, 30 Jul 2014 17:54:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: introduce test_issubvolname() for
 simplicity
Message-ID: <20140730155431.GX1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53D1F65A.7030606@jp.fujitsu.com>
 <20140729133208.GS1553@twin.jikos.cz>
 <53D85F5D.40301@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53D85F5D.40301@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 30, 2014 at 11:58:37AM +0900, Satoru Takeuchi wrote:
> Hi David,
> 
> (2014/07/29 22:32), David Sterba wrote:
> >On Fri, Jul 25, 2014 at 03:16:58PM +0900, Satoru Takeuchi wrote:
> >>From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> >>
> >>There are many duplicated codes to check if the given string is
> >>correct subvolume name. Introduce test_issubvolname() for this
> >>purpose for simplicity.
> >
> >Please move it to utils.c
> 
> OK, I'll do. In addition, how about moving test_isdir() and
> test_issubvolume() to utils.c too? These are also utility functions.

Yes, makes sense.
