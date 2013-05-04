Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:56601 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab3EDKp4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 4 May 2013 06:45:56 -0400
Received: by mail-ob0-f176.google.com with SMTP id er7so2058086obc.21
        for <linux-btrfs@vger.kernel.org>; Sat, 04 May 2013 03:45:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <loom.20130503T132412-316@post.gmane.org>
References: <CADn-QaPVg6C3sMhkasZc+JsoaQ_YQJB-nnoQRKd+XW7sXc1tew@mail.gmail.com>
 <201305030857.55917.russell@coker.com.au> <loom.20130503T132412-316@post.gmane.org>
From: Alexander Skwar <alexanders.mailinglists+nospam@gmail.com>
Date: Sat, 4 May 2013 12:45:34 +0200
Message-ID: <CADn-QaMnyAAiNCUuiM9j2QbGs+G9ucG=84BUJB+FkvPGhAAWqw@mail.gmail.com>
Subject: Re: btrfs subv list -> ERROR: Failed to lookup path for root 0 - No
 such file or directory
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi again.

Well, it still doesn't work reliably.

a@ask-home:~$ sudo `which btrfs` subv list /data
ERROR: Failed to lookup path for root 0 - No such file or directory

While I ran the "list" command, I had, in another terminal, "btrfs
subv snapshot" or "btrfs subv delete" running. At the very same time.

Which additional information should I provide?

Thanks,
Alexander

On Fri, May 3, 2013 at 1:24 PM, Alexander Skwar
<alexanders.mailinglists+nospam@gmail.com> wrote:
> Hi Russel
>
> Russell Coker <russell <at> coker.com.au> writes:
>
>> I asked a similar question about 10 days ago and got the below response
> which
>> solved it for me.
>
>
> Thanks a lot. This solved it for me as well.
>
> Cheers,
> Alexander
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 


Alexander
-- 
=>        Google+ => http://plus.skwar.me         <==
=> Chat (Jabber/Google Talk) => a.skwar@gmail.com <==
