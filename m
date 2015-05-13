Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933039AbbEMNnb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 09:43:31 -0400
Date: Wed, 13 May 2015 15:43:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/8] Introduce offline fsid/chunk tree uuid change for
 btrfstune.
Message-ID: <20150513134329.GJ23255@suse.cz>
Reply-To: dsterba@suse.cz
References: <1430806606-3226-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20150505152055.GH5099@twin.jikos.cz>
 <5549651D.6020005@cn.fujitsu.com>
 <20150506154347.GC23255@twin.jikos.cz>
 <554C7A6A.8040404@cn.fujitsu.com>
 <20150511162423.GV23255@twin.jikos.cz>
 <555160DF.9050902@cn.fujitsu.com>
 <55517ADC.6000300@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55517ADC.6000300@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 12, 2015 at 12:00:28PM +0800, Anand Jain wrote:
>   I strongly recommend this feature to be part of btrfstune as
>   of now, as originally planned by Qu. When its time to move
>   to btrfs cli we could. If we do it wrongly now it would stay
>   there forever.

I agree with that now. The code to change the uuid is straightforward,
we'd got stuck on getting the interface right. At the moment it's more
likely to get it wrong because the properties are not finalized.  A
standalone tool for the uuid change is IMO not the right way either,
btrfstune is usually packaged already.

I'll go through the patches and take the core changes + the btrfstune
interface from v1.

Thank you both for the feedback.
