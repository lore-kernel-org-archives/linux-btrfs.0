Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:59936 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3H0U4k (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Aug 2013 16:56:40 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 231047C06A5
	for <linux-btrfs@vger.kernel.org>; Tue, 27 Aug 2013 14:56:40 -0600 (MDT)
Date: Tue, 27 Aug 2013 16:56:37 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Jeff Mahoney <jeffm@suse.com>
CC: Josef Bacik <jbacik@fusionio.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: add support for asserts
Message-ID: <20130827205637.GM29654@localhost.localdomain>
References: <1377550566-10941-1-git-send-email-jbacik@fusionio.com>
 <521CFDD8.6030205@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <521CFDD8.6030205@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Aug 27, 2013 at 03:28:24PM -0400, Jeff Mahoney wrote:
> On 8/26/13 4:56 PM, Josef Bacik wrote:
> > One of the complaints we get a lot is how many BUG_ON()'s we have.  So to help
> > with this I'm introducing a kconfig option to enable/disable a new ASSERT()
> > mechanism much like what XFS does.  This will allow us developers to still get
> > our nice panics but allow users/distros to compile them out.  With this we can
> > go through and convert any BUG_ON()'s that we have to catch actual programming
> > mistakes to the new ASSERT() and then fix everybody else to return errors.  This
> > will also allow developers to leave sanity checks in their new code to make sure
> > we don't trip over problems while testing stuff and vetting new features.
> > Thanks,
> 
> I don't think the complaint is so much about the number of BUG_ONs, but
> that there's no distinction between something that is supposed to be
> impossible and something that is improbable. The BUG_ONs to keep code
> correctness are good and are littered all over the kernel with positive
> results. The BUG_ONs that are there in place of real error handling
> served their purpose and need to be replaced.
> 
> So, I don't know if it's a net win to compile the "good" BUG_ONs out of
> the code. Especially if a user runs into something strange yet familiar
> and the first response is "oh, huh, can you rebuild with asserts enabled?"
> 

Either I provide an option for it or distros do it themselves, this cuts out the
middle man.  I'd really rather they just be on all the time since they aren't
things we should hit anyway, but at least this way people have a choice.
Thanks,

