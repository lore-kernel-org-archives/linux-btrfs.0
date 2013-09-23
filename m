Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43107 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3IWM4z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Sep 2013 08:56:55 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa1so3557618pad.33
        for <linux-btrfs@vger.kernel.org>; Mon, 23 Sep 2013 05:56:55 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 0/9] enhance btrfs qgroup show command
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <pan$a3bb6$bcc83f63$430b22dd$bd36c43d@cox.net>
Date: Mon, 23 Sep 2013 20:56:49 +0800
Cc: linux-btrfs@vger.kernel.org
Message-Id: <F83FBE02-86FA-4CE3-9EB1-4D275AF6A41C@gmail.com>
References: <50C068D4.6020105@cn.fujitsu.com> <loom.20130922T170658-776@post.gmane.org> <523F95C4.1080404@cn.fujitsu.com> <CAFfJ-R46gqeMOH3bKPPnghmPZ7CziTmYghXJhgOzEoQ_vTJ6Pw@mail.gmail.com> <523FA4EB.3060201@cn.fujitsu.com> <pan$a3bb6$bcc83f63$430b22dd$bd36c43d@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

> Wang Shilong posted on Mon, 23 Sep 2013 10:18:19 +0800 as excerpted:
> 
>> On 09/23/2013 09:53 AM, Dusty Mabe wrote:
> 
>>> There is one other thing I have noticed while playing around
>>> with quota and qgroups. If I delete subvolumes I can manage to get some
>>> of the qgroup information to be reported as a negative number. If you
>>> are interested check out my steps at
>>> http://dustymabe.com/2013/09/22/btrfs-how-big-are-my-snapshots/ . The
>>> system I was using was Fedora 19 (so not the latest stuff so this may
>>> be a known issue already).
> 
>> I will take a look at this issue.
> 
> FWIW, I remember seeing discussion of the negative qgroup numbers on-
> list, but as I don't use quotas I didn't track resolution.   So it should 
> indeed be a known issue, but I'm not sure if it's fixed or someone's at 
> least working on it yet or not.

I think this problem reported by Dusty is different from before.

Previously, we discussed about negative numbers because quota rescan
has not been implemented.

In Dusty's reproduced steps, there are no parent qgroups. So i think every
qgroup should works as expected, if negative numbers come out, it must
be a *bug*.

Thanks,
Wang
> 
> But that might give you a duplicating instance if you need one, anyway.  
> (Unless of course Dusty reported it earlier too and that's what I'm 
> remembering.)
> 
> -- 
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

