Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:38376 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759734Ab3EDOuL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 May 2013 10:50:11 -0400
Received: by mail-da0-f47.google.com with SMTP id k13so1202767dae.6
        for <linux-btrfs@vger.kernel.org>; Sat, 04 May 2013 07:50:10 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: btrfs subv list -> ERROR: Failed to lookup path for root 0 - No such file or directory
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <CADn-QaMnyAAiNCUuiM9j2QbGs+G9ucG=84BUJB+FkvPGhAAWqw@mail.gmail.com>
Date: Sat, 4 May 2013 22:50:04 +0800
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Message-Id: <CB6E97C9-6354-4F08-95EA-2E056EB7082B@gmail.com>
References: <CADn-QaPVg6C3sMhkasZc+JsoaQ_YQJB-nnoQRKd+XW7sXc1tew@mail.gmail.com> <201305030857.55917.russell@coker.com.au> <loom.20130503T132412-316@post.gmane.org> <CADn-QaMnyAAiNCUuiM9j2QbGs+G9ucG=84BUJB+FkvPGhAAWqw@mail.gmail.com>
To: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

hello,

> Hi again.
> 
> Well, it still doesn't work reliably.
> 
> a@ask-home:~$ sudo `which btrfs` subv list /data
> ERROR: Failed to lookup path for root 0 - No such file or directory

This error message should not be printed, in fact, we only print this error
message when errors except ENOENT happens.

I use the latest  btrfs-progs, and i can not reproduce the problem, would you please
double check with this url:
https://git.kernel.org/cgit/linux/kernel/git/mason/btrfs-progs.git/

By the way, what kernel version do you use..

I just use the latest Btrfs, and hit a kernel bug but not the user-land problems.

Thanks,
Wang
> 

> While I ran the "list" command, I had, in another terminal, "btrfs
> subv snapshot" or "btrfs subv delete" running. At the very same time.
> 
> Which additional information should I provide?
> 
> Thanks,
> Alexander
> 
> On Fri, May 3, 2013 at 1:24 PM, Alexander Skwar
> <alexanders.mailinglists+nospam@gmail.com> wrote:
>> Hi Russel
>> 
>> Russell Coker <russell <at> coker.com.au> writes:
>> 
>>> I asked a similar question about 10 days ago and got the below response
>> which
>>> solved it for me.
>> 
>> 
>> Thanks a lot. This solved it for me as well.
>> 
>> Cheers,
>> Alexander
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> -- 
> 
> 
> Alexander
> -- 
> =>        Google+ => http://plus.skwar.me         <==
> => Chat (Jabber/Google Talk) => a.skwar@gmail.com <==
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

