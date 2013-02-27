Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:58943 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759605Ab3B0S0T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 13:26:19 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 8B1C99A0425
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 11:26:19 -0700 (MST)
Date: Wed, 27 Feb 2013 13:26:17 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
CC: Josef Bacik <JBacik@fusionio.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs crash when low on memory.
Message-ID: <20130227182617.GI19641@localhost.localdomain>
References: <20130227052247.GA20213@redhat.com>
 <20130227132736.GH19641@localhost.localdomain>
 <CAFDW0jK6zigx0YgVMHomUkRQkqpw5mUgkdeynv36LUiQn4XTxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAFDW0jK6zigx0YgVMHomUkRQkqpw5mUgkdeynv36LUiQn4XTxg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 27, 2013 at 07:31:11AM -0700, Ahmet Inan wrote:
> > Yeah we have a lot of
> >
> > ptr = kmalloc();
> > BUG_ON(ptr);
> >
> > everywhere.  I'll fix this one up but I really need to sit down and go through
> > all of them and make sure we do the right thing in all these places.  Thanks,
> 
> But what would be the right thing to do when you got no memory?
> Spinlock until you can kmalloc? Pre-reserve some memory?
>

Return ENOMEM?  We have a way to abort transactions now, if it's in a horrible
of enough spot we can just abort the transaction and let the user deal with the
aftermath, it's nicer than panicing.  Thanks,

Josef 
