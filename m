Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37589 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbbEGTsm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 May 2015 15:48:42 -0400
Received: by widdi4 with SMTP id di4so3988592wid.0
        for <linux-btrfs@vger.kernel.org>; Thu, 07 May 2015 12:48:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150507162331.GG23255@twin.jikos.cz>
References: <mig2nl$mrr$1@ger.gmane.org> <20150507162331.GG23255@twin.jikos.cz>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Thu, 7 May 2015 22:48:00 +0300
Message-ID: <CAGqmi75giuU9jJ2qRryxG2eDve=3CAzO_EDgg-djkvZE2w-n7g@mail.gmail.com>
Subject: Re: Kernel 3.19 and btrfs
To: dsterba@suse.cz, Christian <cdysthe@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ubuntu provide own patched kernel as i know.

Christian, if you have 3.19-15 kernel(shiped with 15.04 by default),
it has affected by deadlock bug while replaying journal.
But as i see in 3.19-16 (you can update) this issues has been fixed.

So, it you install latest updates, all must be okay.

2015-05-07 19:23 GMT+03:00 David Sterba <dsterba@suse.cz>:
> On Thu, May 07, 2015 at 12:09:23PM -0400, Christian wrote:
>> I am relying on btrfs on a couple of work laptops now and things seems
>> to work. I'm on Ubuntu 15.04. However, I've seen some horror stories
>> about problems with btrfs on this kernel version. Since Ubuntu 15.04
>> comes with 3.19 I'm a bit worried I am going to get in trouble at some
>> point. I'm not technical enough to understand what the threat level is.
>
> The bug has been fixed in 3.19.5. The 3.19(.0) release itself is not
> affected either.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Have a nice day,
Timofey.
