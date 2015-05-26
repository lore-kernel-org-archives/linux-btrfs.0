Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:34307 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbbEZT3X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 May 2015 15:29:23 -0400
Received: by igbhj9 with SMTP id hj9so68844182igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 May 2015 12:29:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1432666245.4677.15.camel@kepstin.ca>
References: <20150526173634.GU11340@wantstofly.org>
	<20150526180820.GG16826@carfax.org.uk>
	<CAJCQCtQsCU9OhSPRjqTS30i8KeC-_aa9SG+qmViA_q5po00QrQ@mail.gmail.com>
	<1432666245.4677.15.camel@kepstin.ca>
Date: Tue, 26 May 2015 13:29:22 -0600
Message-ID: <CAJCQCtQTEKectBbzVS822_5GLL6usX6wzgxh8XfiVTGRVa2PvQ@mail.gmail.com>
Subject: Re: intermittent -ENOSPC errors on btrfs filesystem with 170G free
From: Chris Murphy <lists@colorremedies.com>
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 26, 2015 at 12:50 PM, Calvin Walton
<calvin.walton@kepstin.ca> wrote:
> On Tue, 2015-05-26 at 12:18 -0600, Chris Murphy wrote:
>> Oh yeah easy to miss, but obvious once pointed out:
>>
>> > Data, single: total=227.94GiB, used=58.16GiB
>>
>> I thought we had automatic deallocation of unused chunks but I guess
>> it hasn't landed yet.
>
> We do have automatic deallocation of unused chunks. (I know it's in
> 4.0, dunno about earlier versions.)
>
> Unfortunately, this only deallocates *completely* unused chunks

oic.

-- 
Chris Murphy
