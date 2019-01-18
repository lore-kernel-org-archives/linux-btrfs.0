Return-Path: <SRS0=o3FP=P2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4176C07EBF
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 17:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A767020823
	for <linux-btrfs@archiver.kernel.org>; Fri, 18 Jan 2019 17:33:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfARRdj (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 18 Jan 2019 12:33:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:37244 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727527AbfARRdj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 18 Jan 2019 12:33:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id EC507AF3F;
        Fri, 18 Jan 2019 17:21:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 17407DA773; Fri, 18 Jan 2019 18:20:57 +0100 (CET)
Date:   Fri, 18 Jan 2019 18:20:57 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 6/6] btrfs: refactor btrfs_find_device() return error code
Message-ID: <20190118172056.GC2900@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1547739153-6916-1-git-send-email-anand.jain@oracle.com>
 <1547739153-6916-7-git-send-email-anand.jain@oracle.com>
 <20190117154922.GU2900@twin.jikos.cz>
 <8e14c714-d869-f8a8-9832-610313d2254b@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e14c714-d869-f8a8-9832-610313d2254b@oracle.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Jan 18, 2019 at 02:13:26PM +0800, Anand Jain wrote:
> 
> 
> On 01/17/2019 11:49 PM, David Sterba wrote:
> > On Thu, Jan 17, 2019 at 11:32:33PM +0800, Anand Jain wrote:
> >> Refactor btrfs_find_device() to return standard error code.
> > 
> > Do you intend to add more error codes?
> 
>   No actually.
> 
>   code like this ...
>      if (PTR_ERR(device) == -ENOENT)
>   can be
>      if (IS_ERR(device))
> 
> 
> > A NULL is valid in case it's
> > clear that it always means 'device not found'.
> > 
> 
>   Oh. I am not too particular, I am ok to drop this patch.
> 
>   The thought process was.. having btrfs_find_device() to return standard
>   err code made code at @@ -2404,8 +2404,6 @@; @@ -2419,13 +2417,9 @@;
>   simpler.

Well, that piece of code is simpler but when compared to the amount of
other changes in the rest it's not making it simpler.

>   And as ioctls already return -ENODEV (though it might not be correct
>   one),

Unrelated to this patch, but I tend to agree that ENODEV is wrong.
However it's been in use for a long time so we can't change easily.

>   so if btrfs_find_device() could return -ENODEV (instead of
>   -ENOENT) then there are few more places where code can be just ..
>      if (IS_ERR(device))
> 	return PTR_ERR(device);

I've seen a lot return values of btrfs_find_device are for internal
purposes so the translation from NULL pointer to ENODEV/ENOENT does not
happen that often. In some contexts it's even something different like
EUCLEAN, but I maybe see the motivation to change it to ERR_PTR, as
btrfs_find_device_by_devspec and btrfs_find_device_missing_or_by_path
return that - btrfs_find_device is different here.
