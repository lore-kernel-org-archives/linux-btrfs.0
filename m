Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:60186 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751004AbdEaUaC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 31 May 2017 16:30:02 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1dGAFh-0006pk-Tb
        for linux-btrfs@vger.kernel.org; Wed, 31 May 2017 22:29:57 +0200
Date: Wed, 31 May 2017 22:29:57 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: Debugging Deadlocks?
Message-ID: <20170531202957.7twakbbbmyqu62bs@angband.pl>
References: <CAMp4zn9Qqx_T03-Vn6zZxo3OkTRfWeHrgOkefmc4JdzzfswAyA@mail.gmail.com>
 <pan$36b2c$8dfce5e1$e29079a0$42822241@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <pan$36b2c$8dfce5e1$e29079a0$42822241@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 31, 2017 at 06:47:09AM +0000, Duncan wrote:
> Sargun Dhillon posted on Tue, 30 May 2017 09:12:39 -0700 as excerpted:
> > currently, in the process of moving to our own patchset atop vanilla
> > 4.10+
> 
> Good for getting off kernel 4.8, as in mainline kernel terms that's only 
> a short-term stable release and support has now ended.

In fact, support for 4.10 has already ended too.

You either stick with LTS (currently 4.9) or keep upgrading to the
newest-and-greatest bleeding edge as soon as it's released.
For production machines, the choice is obvious.

-- 
Don't be racist.  White, amber or black, all beers should be judged based
solely on their merits.  Heck, even if occasionally a cider applies for a
beer's job, why not?
On the other hand, corpo lager is not a race.
