Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kolab.zavadatar.com ([46.101.124.0]:56342 "EHLO
	kolab.zavadatar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859AbcC2TYf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 15:24:35 -0400
Date: Tue, 29 Mar 2016 22:24:29 +0300
From: Yauhen Kharuzhy <yauhen.kharuzhy@zavadatar.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Global hotspare functionality
Message-ID: <20160329192428.GA27148@jeknote.loshitsa1.net>
References: <20160318193937.GA21352@jek-Latitude-E7440>
 <56FA9420.8020503@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <56FA9420.8020503@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 29, 2016 at 10:41:36PM +0800, Anand Jain wrote:
> 
> >Issue 2.
> >At start of autoreplacig drive by hotspare, kernel craches in transaction
> >handling code (inside of btrfs_commit_transaction() called by autoreplace initiating
> >routines). I 'fixed' this by removing of closing of bdev in btrfs_close_one_device_dont_free(), see
> >https://bitbucket.org/jekhor/linux-btrfs/commits/dfa441c9ec7b3833f6a5e4d0b6f8c678faea29bb?at=master
> >(oops text is attached also). Bdev is closed after replacing by
> >btrfs_dev_replace_finishing(), so this is safe but doesn't seem
> >to be right way.
> 
>  I have sent out V2. I don't see that issue with this,
>  could you pls try ?

Sure. In progresss now.

 
> >Issue 4.
> >Autoreplacement code doesn't start replacing at mounting in degraded mode,
> >even if hotspare exists. We need this feature, so I added check for missing
> >drives also, not only for failed, to checking if replacement needed.
> 
>  No. No. No please don't do that, it would lead to trouble in handing
>  slow devices. I purposely didn't do it.

Hmm. Can you explain please? Sometimes admins may want to have
autoreplacement working automatically if drive was failed and removed
before unmounting and remounting again. The simplest way to achieve this —
add spare and always mount FS with 'degraded' option (we need to use
this option in any case if we have root fs on RAID, for instance, to
avoiding non-bootable state). So, if the autoreplacement code will check for
missing drives also, this will working without user intervention. To
allow user to decide if he wants autoreplacement, we can add mount
option like '(no)hotspare' (I have done this already for our project and
will send patch after rebasing onto your new series). Yes, there are
side effects exists if you want to make some experiments with missing
drives in FS, but you can disable autoreplacement for such case.

If you know about any pitfalls in such scenarios, please point me to
them, I am newbie in FS-related kernel things.


>  Also kindly note that, in volume manage / storage context things
>  should continue to work in degraded mode automatically, and it
>  shouldn't wait for user's opinion. If it don't do that, then
>  there is no point in having a volume manager. But as of now btrfs has
>  already made degraded as non default choice. There is something else
>  new which is needed and it can be a separate RFC, not part of this
>  patch set.
> 
> 
>  Please try. V2 sent out.

OK, I am going to testing now. 

-- 
Yauhen Kharuzhy
