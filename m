Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42004 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbcATOtx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jan 2016 09:49:53 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aLu51-0002u5-HK
	for linux-btrfs@vger.kernel.org; Wed, 20 Jan 2016 15:49:51 +0100
Received: from 87-127-115-15.static.enta.net ([87.127.115.15])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jan 2016 15:49:51 +0100
Received: from 6401e46d by 87-127-115-15.static.enta.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Jan 2016 15:49:51 +0100
To: linux-btrfs@vger.kernel.org
From: Al <6401e46d@opayq.com>
Subject: Re: Why is dedup inline, not delayed (as opposed to offline)? Explain like I'm five pls.
Date: Wed, 20 Jan 2016 14:49:45 +0000 (UTC)
Message-ID: <loom.20160120T154524-556@post.gmane.org>
References: <loom.20160116T132316-196@post.gmane.org> <pan$6d016$7902b96d$a10088a$d023ef02@cox.net> <CAGfcS_mepN3bcgSo6qgjVAyROoRpX3G05dAm=-g-eOhSkv+GZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Rich Freeman <r-btrfs <at> thefreemanclan.net> writes:

> I think he is actually suggesting a hybrid approach where a bit of
> effort is done during operations to greatly streamline out-of-line
> deduplication.  I'm not sure how close we are to that already, or if
> any room for improvement remains.
> 
> --

Hopefully, we can tweak the split between in-memory and on blkdev. I don't
see myself needing in-memory much (cc'd email with attachments perhaps?).



