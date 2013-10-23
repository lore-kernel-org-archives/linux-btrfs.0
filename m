Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49235 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab3JWS1k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Oct 2013 14:27:40 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VZ39e-00045V-UB
	for linux-btrfs@vger.kernel.org; Wed, 23 Oct 2013 20:27:38 +0200
Received: from cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com ([86.0.163.207])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 20:27:38 +0200
Received: from m_btrfs by cpc21-stap10-2-0-cust974.12-2.cable.virginmedia.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Oct 2013 20:27:38 +0200
To: linux-btrfs@vger.kernel.org
From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: 8 days looped? (btrfsck --repair --init-extent-tree)
Date: Wed, 23 Oct 2013 19:27:28 +0100
Message-ID: <l494e6$jg6$1@ger.gmane.org>
References: <l46ece$pi4$1@ger.gmane.org> <20131022181736.GB27304@localhost.localdomain> <l48q6q$e50$1@ger.gmane.org> <20131023162145.GE10632@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
In-Reply-To: <20131023162145.GE10632@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 23/10/13 17:21, Josef Bacik wrote:
> On Wed, Oct 23, 2013 at 04:32:51PM +0100, Martin wrote:

>>
>> Any further debug useful?
>>
> 
> Nope I know where it's breaking, I need to fix how we init the extent tree.
> Thanks,

Good stuff.

If of help, I can test new code or a patch for that example. (I'll leave
the disk in place for the time being.)


Thanks,
Martin



