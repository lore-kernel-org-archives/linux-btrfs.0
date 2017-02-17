Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:42081 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1755663AbdBQI0d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Feb 2017 03:26:33 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cedrx-0001cV-HQ
        for linux-btrfs@vger.kernel.org; Fri, 17 Feb 2017 09:26:21 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Opps.. Should be 4.9/4.10 Experiences
Date: Fri, 17 Feb 2017 08:26:15 +0000 (UTC)
Message-ID: <pan$1fe63$b02c9dfa$efbc9dc2$1ccd0342@cox.net>
References: <CAK5rZE7mDy+8hkm74UVS81Xht=QxvNOmW=ZfYqpHmnqGZHbMbA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Imran Geriskovan posted on Thu, 16 Feb 2017 13:42:09 +0200 as excerpted:

> Opps.. I mean 4.9/4.10 Experiences
> 
> On 2/16/17, Imran Geriskovan <imran.geriskovan@gmail.com> wrote:
>> What are your experiences for btrfs regarding 4.10 and 4.11 kernels?
>> I'm still on 4.8.x. I'd be happy to hear from anyone using 4.1x for a
>> very typical single disk setup. Are they reasonably stable/good enough
>> for this case?

I ran 4.9 and have been on 4.10 since before rc1.  Btrfs has been fine 
here, tho there have been some late rc7/8 fixes.  I've had and still have 
some 4.10 issues, but they're amdgpu, not btrfs related.  (Unfortunately, 
between working long hours and being sick partly as a result, I've had 
little time to report them, but booting with amdgpu.dpm=0 has let me 
continue running 4.10-git, tho I don't know exactly why if I'm not going 
to have time to report problems anyway.)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

