Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f53.google.com ([209.85.219.53]:64175 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754842Ab2LRONw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Dec 2012 09:13:52 -0500
Received: by mail-oa0-f53.google.com with SMTP id j6so648369oag.40
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Dec 2012 06:13:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20121218140409.GD2403@localhost.localdomain>
References: <CAOeZVifRT=63Md+03bu9Fj8a9+p+c32_J-FRH5uZdiv6n=zNXw@mail.gmail.com>
	<20121218140409.GD2403@localhost.localdomain>
Date: Tue, 18 Dec 2012 19:43:51 +0530
Message-ID: <CAOeZVidsxcR16t3v6OKU6fAJbB_S64sbQM1CyL2D_t_CtE1ajg@mail.gmail.com>
Subject: Re: BTree lock contention
From: Atri Sharma <atri.jiit@gmail.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks.

I shall mark it as in progress then.

For writer's contention, I was thinking of decreasing the lock
granularity. I have not really thought about it deeply yet, but my
initial plans are to identify areas where we can distribute the locks,
and maybe use techniques such as combining trees.

Thanks a ton,

Atri

On Tue, Dec 18, 2012 at 7:34 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Mon, Dec 17, 2012 at 09:24:23PM -0700, Atri Sharma wrote:
>> Hi All,
>>
>> I was looking through the project ideas page for picking up a project
>> do start working with BTRFS. I am really interested in Btree lock
>> contention project, but it seems to be marked that it has already been
>> done in v3.1
>>
>> Is the project still open? Can I work on it?
>>
>
> Go for it, we still have plenty of lock contention, it's just in 3.1 we switched
> to a read/write lock which helped a bunch.  Still if you have all writers you
> are going to hit quite a bit of lock contention, especially on the root nodes.
> If you have ideas go for it.  Thanks,
>
> Josef



-- 
Regards,

Atri
l'apprenant
