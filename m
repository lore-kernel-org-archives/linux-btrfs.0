Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout3.netcologne.de ([89.1.8.213]:38130 "EHLO
        cc-smtpout3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753998AbcIGKAK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 7 Sep 2016 06:00:10 -0400
Subject: Re: kworker threads may be working saner now instead of using 100% of
 a CPU core for minutes (Re: Still not production ready)
To: Martin Steigerwald <martin@lichtvoll.de>,
        BTRFS <linux-btrfs@vger.kernel.org>
References: <8336788.myI8ELqtIK@merkaba> <2314143.TOm3LuQPV3@merkaba>
From: Christian Rohmann <crohmann@netcologne.de>
Message-ID: <a208120b-f6e1-7173-9cfc-e898d50c6f9d@netcologne.de>
Date: Wed, 7 Sep 2016 11:53:04 +0200
MIME-Version: 1.0
In-Reply-To: <2314143.TOm3LuQPV3@merkaba>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03/20/2016 12:24 PM, Martin Steigerwald wrote:
>> btrfs kworker thread uses up 100% of a Sandybridge core for minutes on
>> > random write into big file
>> > https://bugzilla.kernel.org/show_bug.cgi?id=90401
> I think I saw this up to kernel 4.3. I think I didn´t see this with 4.4 
> anymore and definately not with 4.5.
> 
> So it may be fixed.
> 
> Did anyone else see kworker threads using 100% of a core for minutes with 4.4 
> / 4.5?

I run 4.8rc5 and currently see this issue. kworking has been running at
100% for hours now, seems stuck there.

Anything I should look at in order to narrow this down to a root cause?


Regards

Christian
