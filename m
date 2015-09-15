Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f44.google.com ([209.85.215.44]:34608 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbbIOUvG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 16:51:06 -0400
Received: by lahg1 with SMTP id g1so86807120lah.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 13:51:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150915203815.GC28645@carfax.org.uk>
References: <CAGqmi77Y3qiEs7aVwXQ-VT9b0yF4ViAA1szMicY5_GEXQaRYVw@mail.gmail.com>
 <20150915203815.GC28645@carfax.org.uk>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 15 Sep 2015 23:50:25 +0300
Message-ID: <CAGqmi77_CyOvu7sqP0yNZjsuDP-NcuK691o=5x8o2hCU++1iJw@mail.gmail.com>
Subject: Re: Csum I/O Error
To: Hugo Mills <hugo@carfax.org.uk>, Timofey Titovets <nefelim4ag@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for tip hugo *_*

2015-09-15 23:38 GMT+03:00 Hugo Mills <hugo@carfax.org.uk>:
> On Tue, Sep 15, 2015 at 10:59:48PM +0300, Timofey Titovets wrote:
>> Hi list,
>> i've catch a io error, caused by csum mismatch
>> Can i force fs to read data?
>> This is really not a cool, if only way is use btrfs restore.
>>
>> #Info vm machin, after power failure get 2 blocks with errors, and one
>> mysql table, can't be readed by mysql (and also, i can't just dump it)
>
>    The data is corrupt, or at the very least deeply untrustworthy. At
> this point, the easiest thing to do is use dd_rescue or ddrescue on
> it, which will skip the unreadable sectors and replace them with
> zeroes -- which is no worse than the random data you're likely to
> encounter from reading the broken data that the FS is (rightly)
> protecting you from.
>
>    Hugo.
>
> --
> Hugo Mills             | A diverse working environment: Di longer you vork
> hugo@... carfax.org.uk | here, di verse it gets
> http://carfax.org.uk/  |
> PGP: E2AB1DE4          |



-- 
Have a nice day,
Timofey.
