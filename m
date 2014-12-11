Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:48978 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933423AbaLKCqH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Dec 2014 21:46:07 -0500
Message-ID: <5489056C.3070109@cn.fujitsu.com>
Date: Thu, 11 Dec 2014 10:46:04 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, "sys.syphus" <syssyphus@gmail.com>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: out of space warning?
References: <CAAe=sHXGpiZN5hKmzv1ynY8x=rH9tMvx86HZP2veLRpAFJN+wg@mail.gmail.com> <5488F370.2060604@pobox.com>
In-Reply-To: <5488F370.2060604@pobox.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: out of space warning?
From: Robert White <rwhite@pobox.com>
To: sys.syphus <syssyphus@gmail.com>, <linux-btrfs@vger.kernel.org>
Date: 2014年12月11日 09:29
> On 12/10/2014 02:54 PM, sys.syphus wrote:
>> I would like to avoid running out of space. is there a way to know
>> that I am getting close? i'd like to make a script that runs as part
>> of my bash prompt and lets me know when i am getting close. i know
>> there are several ways you can run out of space and I'd like to avoid
>> all of them.
>
> Don't do that either. 8-)
>
> (1) you'll grow to hate it.
>
> (2) You know when you are doing things that take a lot of storage. You 
> instinct for system fullness is already part of your brain-meat.
>
> (3) The system isn't going to explode if it runs out of disk space. 
> (old UNIX systems used to halt with system errors because running out 
> of space prevented pipelines from being created, but that's ancient 
> history).
>
> (4) The only _real_ way to run out of space is to be a data hoarder, 
> and no script in the world is going to help you if that's the case. Ha 
> Ha....
(5) Possible known/unknown kernel bug may cause strange ENOSPC during 
balance/replace/scrub... :-)
>
> You don't check your car's gas tank every time you put your foot on 
> the brake, you don't want to check your free space every time your 
> system finishes every tiny command you type.
>
> Scripts like this are possible in bash, but consider that every "ls" 
> or even just enter you type would be followed by a "df" and a "grep" 
> or whatever in whatever window you are using at the time. etc.
>
> IF you think you are going to run out of space, and you are using 
> _any_ kind of window system, then start a system manager display for a 
> while until you get the feel for how not out of space you really are.
>
> Nothing gets ignored faster than a text element that essentially never 
> changes, and once you get in the habbit of ignoring the text you won't 
> notice when it actually has something to say.
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

