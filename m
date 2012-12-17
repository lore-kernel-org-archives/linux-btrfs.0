Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41079 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab2LQMxo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Dec 2012 07:53:44 -0500
Received: by mail-oa0-f46.google.com with SMTP id h16so5858856oag.19
        for <linux-btrfs@vger.kernel.org>; Mon, 17 Dec 2012 04:53:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121217123800.GI19051@carfax.org.uk>
References: <CAOeZVic4=4tZK3c6jit-K_NYp=PCJFOL3RNJmEXFscKAANjFQQ@mail.gmail.com>
	<CAOeZViccr19yumXMOkdpNrGO1fGghbyVjSErW0F2eF65Sj0rsw@mail.gmail.com>
	<20121217123800.GI19051@carfax.org.uk>
Date: Mon, 17 Dec 2012 18:23:41 +0530
Message-ID: <CAOeZVifL=6+3ojkxv4u1ZJTZi3dWdLb4M6jR7fGacEjbD+WfCw@mail.gmail.com>
Subject: Re: Regarding contribution to BTRFS
From: Atri Sharma <atri.jiit@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 17, 2012 at 6:08 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Dec 17, 2012 at 05:39:45PM +0530, Atri Sharma wrote:
>> Sorry,the email is incomplete.
>>
>> As mentioned above, I am a C developer and really interested in file
>> systems, and the Fedora community redirected me to BTRFS. I would
>> really love to contribute to btrfs.
>>
>> Please let me know how I can proceed further, and what are the
>> potential areas I can work in.
>
>    Well, there's this page on the wiki:
>
>    https://btrfs.wiki.kernel.org/index.php/Project_ideas
>
>    As for how to proceed -- decide on a project you like the look of,
> mark it as in progress on the wiki, and submit patches to here as an
> RFC when you think you've got something worth looking at.
>
>    If you come up with something else that's not on the list, I'd
> suggest putting a brief description of it in this mailing list, just
> to check whether there's someone else working on it, or if it's an
> unexpectedly difficult or controversial idea.

Hi Hugo,

Thanks for your reply.

I have been studying concurrency lately, so I would love to work in that area.

Specifically, I would love to work on 'Btree lock contention'.

I have some ideas for it, specifically I would like to see if we can
reduce the lock granularity or spread the threads blocking over time,
or maybe use something like combining trees.

Please let me know if that is ok.

Atri


--
Regards,

Atri
l'apprenant
