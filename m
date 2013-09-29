Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38490 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753309Ab3I2CKt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 28 Sep 2013 22:10:49 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VQ6T9-0007CY-UH
	for linux-btrfs@vger.kernel.org; Sun, 29 Sep 2013 04:10:47 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 04:10:47 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 29 Sep 2013 04:10:47 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: Corrupt btrfs filesystem recovery... What best instructions?
Date: Sun, 29 Sep 2013 03:10:37 +0100
Message-ID: <l2826k$1uc$1@ger.gmane.org>
References: <l27agq$u5a$1@ger.gmane.org> <l27mn1$squ$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <l27mn1$squ$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 28/09/13 23:54, Martin wrote:
> On 28/09/13 20:26, Martin wrote:
> 
>> ... btrfsck bombs out with LOTs of errors...
>>
>> How best to recover from this?
>>
>> (This is a 'backup' disk so not 'critical' but it would be nice to avoid
>> rewriting about 1.5TB of data over the network...)
>>
>>
>> Is there an obvious sequence/recipe to follow for recovery?
> 
> 
> I've got the drive reliably working with the sata limited to 3Gbit/s.
> What is the best sequence to try to tidy-up and carry on with the 1.5TB
> or so of data on there, rather than working from scratch?
> 
> 
> So far, I've only run btrfsck since the corruption...

So...

Any options for btrfsck to fix things?

Or is anything/everything that is fixable automatically fixed on the
next mount?

Or should:

btrfs scrub /dev/sdX

be run first?

Or?


What does btrfs do (or can do) for recovery?

Advice welcomed,

Thanks,
Martin




