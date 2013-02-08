Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:41186 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760341Ab3BHTRx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Feb 2013 14:17:53 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 964FC9A04DF
	for <linux-btrfs@vger.kernel.org>; Fri,  8 Feb 2013 12:17:52 -0700 (MST)
Date: Fri, 8 Feb 2013 14:17:50 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Marguerite Su <i@marguerite.su>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs: Error removing orphan entry, stopping orphan cleanup.
 could not do orphan cleanup -22
Message-ID: <20130208191750.GA10931@localhost.localdomain>
References: <CAK0PdAkGdGWg8TzrDK0hRgcrqqkTF7XrcOHX2wh_7DLG3G0CLA@mail.gmail.com>
 <20130205193549.GC26092@localhost.localdomain>
 <CAK0PdAmnZgE2+nRzrrK_FLa1xcpZPLHyUN69Kx7W5rRVV2bvTA@mail.gmail.com>
 <20130205204523.GD26092@localhost.localdomain>
 <CAK0PdAnMr20LgPriUz40YPg+uu08xqabE25Bh7W_h-Tzq+LEbA@mail.gmail.com>
 <20130206151526.GF26092@localhost.localdomain>
 <CAK0PdAmXh_mYQU2HSOcVXDQ-NH7AvAM5iYdzdusxsTgR6w13GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAK0PdAmXh_mYQU2HSOcVXDQ-NH7AvAM5iYdzdusxsTgR6w13GQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 08, 2013 at 11:36:48AM -0700, Marguerite Su wrote:
> 
> 
> 
> On Wed, Feb 6, 2013 at 11:15 PM, Josef Bacik <jbacik@fusionio.com<mailto:jbacik@fusionio.com>> wrote:
> 
> Btrfs-next is based on 3.7, you should be able to just git diff v3.7.. >
> whatever.patch and get all the changes you need.  Thanks,
> 
> Hi, Josef,
> 
> Sorry to bother you again. I tried for days and asked some of my friends, but I'm still confused about what you want me to do and how to do...
> 
> I check the #btrfs-next[1], its latest tag is v3.4-rc2 and there's only one master branch. There's no `v3.7` around there...So I'm confused about what you meant. Can you be more detailed ?
> 
> I know I need a diff...but how...and which repo should I apply it on? my /usr/src/linux or #btrfs-next itself?
> 
> Thanks a lot
> 

Oh sorry I have the tags locally because I pull linus's tags onto my tree, but I
don't push them out.  So pull my tree (I just pushed another fix for this
problem out yesterday so it definitely should be fixed) and just do

git diff 29594404d7fe73cd80eaa4ee8c43dcc53970c60e.. > btrfs.patch

and that should work.  Thanks,

Josef
