Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:55049 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751773AbdHBDWx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Aug 2017 23:22:53 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dckFA-00083n-Nv
        for linux-btrfs@vger.kernel.org; Wed, 02 Aug 2017 05:22:44 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS error: bad tree block start 0 623771648
Date: Wed, 2 Aug 2017 03:22:32 +0000 (UTC)
Message-ID: <pan$4d60$25808f7d$ec32dcbb$a11fc6f7@cox.net>
References: <CAN_=hu0k8+FmrSOw5P5TAZyjzjvGyqv_ByYr27s8rZY456k87Q@mail.gmail.com>
        <20170801110805.09226fc3@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Tue, 01 Aug 2017 11:08:05 +0500 as excerpted:

> On Sun, 30 Jul 2017 18:14:35 +0200 "marcel.cochem"
> <marcel.cochem@googlemail.com> wrote:
> 
>> I am pretty sure that not all data is lost as i can grep thorugh the
>> 100 GB SSD partition. But my question is, if there is a tool to rescue
>> all (intact) data and maybe have only a few corrupt files which can't
>> be recovered.
> 
> There is such a tool, see
> https://btrfs.wiki.kernel.org/index.php/Restore

I was going to suggest that too... and even started a reply to do so... 
upon which I read a bit closer and saw he'd actually tried restore 
already...

And before you suggest it, he tried btrfs-find-root as well, and it 
didn't work either, so he can't do the advanced/technical mode of 
restore, feeding it addresses from btrfs-find-root, either. =:^(

It's in the post...

So unfortunately he's pretty much left with manual hacking and scraping, 
and that's at a level beyond what I at least am able to help him with...

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

