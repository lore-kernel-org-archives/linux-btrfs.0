Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35768 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbbHaGfk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Aug 2015 02:35:40 -0400
Date: Mon, 31 Aug 2015 09:32:52 +0300
From: Alexandru Moise <00moses.alexander00@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Remove unneeded cast to s64 for qgroup rfer state
Message-ID: <20150831063252.GA3537@gmail.com>
References: <20150829114553.GA7522@gmail.com>
 <55E3B191.7030800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <55E3B191.7030800@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 31, 2015 at 09:44:49AM +0800, Qu Wenruo wrote:
> >>    >From the perspective of users, qgroup's referenced or exclusive
> >>    is negative,but user can not continue to write data! a workaround
> >>    way is to cast u64 to s64 when doing qgroup reservation
> >
> >I am unable to reproduce this problem without his modification.
> >I could be wrong in reverting this, so I'm gonna CC Wang as well so
> >he is aware of this patch.
> 
> The cast is a workaround for a quite old qgroup bug, which will
> cause excl/rfer overflow to minus.
> 
> The remove of cast rfer/exel now is OK, as qgroup keeps maturing,
> especially after 4.2-rc1 rfer/exel will keep sane under most case
> (exception will be qgroup reassign and subvolume deletion, but will
> not case minus value even under than case).

rfer/exel and reserved are all of type unsigned int, how exactly would
they overflow to minus?

> 
> But I'm not a fan to remove it now.
> As qgroup still has a known huge bug for the qg->reserved part, we
> are aware of it and working on it actively.

Can you tell me more about this known huge bug and how you can
reproduce it using the present implementation?

