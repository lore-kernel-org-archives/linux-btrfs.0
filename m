Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34354 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300AbaHTIW2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Aug 2014 04:22:28 -0400
Date: Wed, 20 Aug 2014 16:22:19 +0800
From: Liu Bo <bo.li.liu@oracle.com>
To: Chris Mason <clm@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: cleanup the same name in end_bio_extent_readpage
Message-ID: <20140820082218.GB30876@localhost.localdomain>
Reply-To: bo.li.liu@oracle.com
References: <1408462342-2581-1-git-send-email-bo.li.liu@oracle.com>
 <53F3A5F4.8080405@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53F3A5F4.8080405@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 19, 2014 at 03:31:00PM -0400, Chris Mason wrote:
> On 08/19/2014 11:32 AM, Liu Bo wrote:
> > We've defined a 'offset' out of bio_for_each_segment_all.
> 
> This isn't causing problems though?  It should just be shadowing the
> bio_for_each_segment_all variable for the duration of the curlies.
> 
> No objection as a cleanup, just making sure I'm not missing something.

It did't cause any problems yet in my testers at least, so just a cleanup.

thanks,
-liubo

