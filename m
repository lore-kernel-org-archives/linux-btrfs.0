Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:48149 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248Ab3E3Mci (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 May 2013 08:32:38 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 4108B7C0687
	for <linux-btrfs@vger.kernel.org>; Thu, 30 May 2013 06:32:38 -0600 (MDT)
Date: Thu, 30 May 2013 08:32:35 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Papp Tamas <tompos@martos.bme.hu>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: oops at mount
Message-ID: <20130530123235.GA9829@localhost.localdomain>
References: <51A73532.6060900@martos.bme.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <51A73532.6060900@martos.bme.hu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 30, 2013 at 05:17:06AM -0600, Papp Tamas wrote:
> hi All,
> 
> I'm new on the list.
> 
> System:
> Distributor ID:	Ubuntu
> Description:	Ubuntu 13.04
> Release:	13.04
> Codename:	raring
> 
> Linux ctu 3.8.0-19-generic #30-Ubuntu SMP Wed May 1 16:35:23 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux
> 
> The symptom is the same with Saucy 3.9 kernel.

Can you try btrfs-next

git://git.kernel.org/pub/scm/linux/kernel/git/josef/btrfs-next.git

if it's still not fixed please file a bug at bugzilla.kernel.org and make sure
the component is set to btrfs.  Thanks,

Josef
