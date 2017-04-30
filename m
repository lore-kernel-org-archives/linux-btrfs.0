Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f194.google.com ([209.85.216.194]:36195 "EHLO
        mail-qt0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1946591AbdD3Q4d (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 30 Apr 2017 12:56:33 -0400
Received: by mail-qt0-f194.google.com with SMTP id t52so14304397qtb.3
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Apr 2017 09:56:33 -0700 (PDT)
Message-ID: <5906173F.70009@gmail.com>
Date: Sun, 30 Apr 2017 12:56:31 -0400
From: "J. Hart" <jfhart085@gmail.com>
Reply-To: jfhart085@gmail.com
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Duncan <1i5t5.duncan@cox.net>
Subject: Re: ERROR: cannot find parent subvolume, can't see reason for it.
References: <20170430000452.2dcc1591@ws>
In-Reply-To: <20170430000452.2dcc1591@ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thank you very much for your thoughtful and thorough reply.   I 
appreciate this very much.

I have finally been able to work past the issue.  It seems that 
send/receive participates in maintaing some sort of "chain of 
custody/ancestry".  I had been using a pre-existing snapshot at the 
destination instead of sending over an identical original via "btrfs 
send".   This seems to have had the effect of "breaking" that "chain", 
causing send to refuse to use that snapshot as a parent.  When the 
original is sent,  send can use it  as such, and the operation I was 
attempting proceeds without error.

On 04/30/2017 03:07 AM, Duncan wrote:
> [This mail was also posted to gmane.comp.file-systems.btrfs.]
>
> J. Hart posted on Sat, 29 Apr 2017 23:10:48 -0400 as excerpted:
>

> I see three previous threads (the first starting on March 25) with you 
> as original poster on the list, all of which have followups to the 
> list, one of which has a single followup from you to someone replying 
> to you, from you as well. I don't however see any followups from you 
> to replies on the other two threads, and only the one followup to 
> someone replying on the one thread. So it may be that you're not 
> getting the replies very well. Are you subscribed to the list? While 
> some posters reply directly to author as
I will try keeping a more careful eye on the archives as you suggest and 
see if I am missing replies.

With Thanks,

J. Hart

