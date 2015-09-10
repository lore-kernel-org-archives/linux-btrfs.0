Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27831 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750877AbbIJXe4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Sep 2015 19:34:56 -0400
Date: Thu, 10 Sep 2015 19:34:44 -0400
From: Chris Mason <clm@fb.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH RFC 00/14] Accurate qgroup reserve framework
Message-ID: <20150910233444.GK9511@ret.masoncoding.com>
References: <1441702615-18333-1-git-send-email-quwenruo@cn.fujitsu.com>
 <55EEA58A.8050503@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <55EEA58A.8050503@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 08, 2015 at 05:08:26PM +0800, Qu Wenruo wrote:
> Sorry for the confusing cover letter title.
> 
> This patch is no longer RFC now.
> It's already a working one, and we're doing stress test to ensure it's
> completely OK, but seems quite good for now.
> 
> To Chris,
> 
> I know the timing I sent the patchset is quite awful, as there is only less
> than 1 week for rc1, and the merge window will close soon.
> 
> But I still hope there would be a small chance we can merge it into early
> v4.3-rc. Maybe rc2 or rc3?
> As the reserve space leaking problem is quite annoying, sometimes even
> making qgroup limit unusable.

Sorry, this is much too big for rc2 or rc3.

> 
> If that's not possible, I'm completely OK with that though, as Linus won't
> be happy about that without doubt.

Lets use the rest of the 4.3 cycle to get reviews (esp from Mark) and
work through any problems.  I'd really like to focus on this and the
subvol deletion accounting

-chris
