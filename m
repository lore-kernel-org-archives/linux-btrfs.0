Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f179.google.com ([209.85.160.179]:34270 "EHLO
	mail-yk0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbbFQAOG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jun 2015 20:14:06 -0400
Received: by ykfl8 with SMTP id l8so27303633ykf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jun 2015 17:14:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$966fb$92ec2f1c$291706f7$cf1b6c68@cox.net>
References: <1434456557.89597618@apps.rackspace.com>
	<20150616122545.GI9850@carfax.org.uk>
	<61CBE6C4-0D06-4F16-B522-4DBB756FBC31@up4.com>
	<pan$966fb$92ec2f1c$291706f7$cf1b6c68@cox.net>
Date: Tue, 16 Jun 2015 18:14:05 -0600
Message-ID: <CAJCQCtRGxCr4GaVwkA0QpK8dYjhaBS0-rmi=ymPxycQiGUa_fg@mail.gmail.com>
Subject: Re: RAID10 Balancing Request for Comments and Advices
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 16, 2015 at 5:58 PM, Duncan <1i5t5.duncan@cox.net> wrote:

> On a current kernel unlike older ones, btrfs actually automates entirely
> empty chunk reclaim, so this problem doesn't occur anything close to near
> as often as it used to.  However, it's still possible to have mostly but
> not entirely empty chunks that btrfs won't automatically reclaim.  A
> balance can be used to rewrite and combine these mostly empty chunks,
> reclaiming the space saved.  This is what Hugo was recommending.

Yes, as little as a -dusage=5 (data chunks that are 5% or less full)
can clear the problem and is very fast, seconds. Possibly a bit
longer, many seconds o single digit minutes is -dusage=15. I haven't
done a full balance in forever.


-- 
Chris Murphy
