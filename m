Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:34522 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934403AbaE3WAo (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 May 2014 18:00:44 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WqUqw-0003sG-UQ
	for linux-btrfs@vger.kernel.org; Sat, 31 May 2014 00:00:42 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginm.net ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 31 May 2014 00:00:42 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginm.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 31 May 2014 00:00:42 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: What to do about snapshot-aware defrag
Date: Fri, 30 May 2014 23:00:24 +0100
Message-ID: <lmav1p$ih7$1@ger.gmane.org>
References: <5388ED6B.8000706@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <5388ED6B.8000706@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

OK... I'll jump in...

On 30/05/14 21:43, Josef Bacik wrote:
> Hello,
> 
> TL;DR: I want to only do snapshot-aware defrag on inodes in snapshots
> that haven't changed since the snapshot was taken.  Yay or nay (with a
> reason why for nay)

[...]
> 
> === Summary and what I need ===
> 
> Option 1: Only relink inodes that haven't changed since the snapshot was
> taken.
> 
> Pros:
> -Faster
> -Simpler
> -Less duplicated code, uses existing functions for tricky operations so
> less likely to introduce weird bugs.
> 
> Cons:
> -Could possibly lost some of the snapshot-awareness of the defrag.  If
> you just touch a file we would not do the relinking and you'd end up
> with twice the space usage.
[...]


Obvious way to go for fast KISS.


One question:

Will option one mean that we always need to mount with noatime or
read-only to allow snapshot defragging to do anything?


Regards,
Martin

