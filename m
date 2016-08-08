Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:35634 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbcHHTBU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Aug 2016 15:01:20 -0400
Received: by mail-qk0-f193.google.com with SMTP id o1so1526781qkd.2
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Aug 2016 12:01:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160808185237.GA9644@carfax.org.uk>
References: <CAMG9ccwK93opLn=qOcceDjExwDHHRaxO=juvcXz4TuWKt_qXeg@mail.gmail.com>
 <CAJCQCtSs5bHZu5NLjVfJLgxL45BdNq7hrmV3VdCLz+WxLEXrMw@mail.gmail.com>
 <CAMG9ccwqnK63sbcF79VndBMitvFjX6pHPCU9YrrZcwEdiQxY5w@mail.gmail.com> <20160808185237.GA9644@carfax.org.uk>
From: Ivan Sizov <sivan606@gmail.com>
Date: Mon, 8 Aug 2016 22:00:59 +0300
Message-ID: <CAMG9ccw9meTUSoH9DVoa7zuhxR-q5N_2W3ULMWFGk7AbnHzKDQ@mail.gmail.com>
Subject: Re: Strange behavior after "rm -rf //"
To: Hugo Mills <hugo@carfax.org.uk>, Ivan Sizov <sivan606@gmail.com>,
        Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-08-08 21:52 GMT+03:00 Hugo Mills <hugo@carfax.org.uk>:
> On Mon, Aug 08, 2016 at 09:38:28PM +0300, Ivan Sizov wrote:
>> P.S. IMHO, log replay by default is a quite dangerous thing. I didn't
>> know about that change and I could lose all files if the live USB had
>> 4.6 kernel))
>
>    Log reply on mount has _always_ been the default, and should remain
> so. It gives you the expected semantics after a power loss: all th
> efiles that you'd written up to the point of the power loss actually
> appear afterwards. (If this didn't happen, you could lose up to 30s of
> writes from before the crash).
>
>    It's only very recently that there's been an option to prevent it,
> which is useful in a limited number of cases (such as trying to
> undelete a file, which is not really a supported operation in any
> case).

I mean only RO mount, of course.

So, will zero-log prevent my files during RW mount?


-- 
Ivan Sizov (SIvan)
