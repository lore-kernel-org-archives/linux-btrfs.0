Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34138 "EHLO
        mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755820AbcILSzx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Sep 2016 14:55:53 -0400
Received: by mail-oi0-f43.google.com with SMTP id m11so329198047oif.1
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Sep 2016 11:55:52 -0700 (PDT)
Subject: Re: Small fs
To: Imran Geriskovan <imran.geriskovan@gmail.com>,
        Duncan <1i5t5.duncan@cox.net>
References: <CAK5rZE49j5QYZJSriG70LVo-9JnRJRfwFA0qRZSEotXpCxJC6A@mail.gmail.com>
 <5440522.9CHaGU5Wjs@merkaba> <pan$238e8$d4dacca2$71255eb4$9f2e5ec1@cox.net>
 <CAK5rZE6X_m6wyTmqRZ8B3TTZsXtEtPT5TaanFfgXKycJoBfsTA@mail.gmail.com>
 <pan$10305$d0b1bd23$a49643ee$465d6f6c@cox.net>
 <CAK5rZE7SMLgPpe8tAQZ9qu=vm+3Gk=73L_h2+tOPEag-0tS0Bg@mail.gmail.com>
 <CAK5rZE7V46=y9is5rmD2HDV2d5MNMiWd++xUszgSqAOY5VQxsA@mail.gmail.com>
 <CAK5rZE55nTKh7u6B56MaGcoezmgOrbjrkzSt+WipcGO1mjEGsw@mail.gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <8dc76c71-aa15-8b9d-87e1-c21732a97779@gmail.com>
Date: Mon, 12 Sep 2016 14:55:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAK5rZE55nTKh7u6B56MaGcoezmgOrbjrkzSt+WipcGO1mjEGsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-12 14:46, Imran Geriskovan wrote:
>> Wait wait wait a second:
>> This is 256 MB SINGLE created
>> by GPARTED, which is the replacement of MANUALLY
>> CREATED 127MB DUP which is now non-existant..
>> Which I was not aware it was a DUP at the time..
>> Peeww... Small btrfs is full of surprises.. ;)
>
> What's more, I also have another 128MB SINGLE
> which I've been using for some years and did not
> bother with its DUP/SINGLENESS. And I compared
> them all to draw some conclusions. Heh..
> That's the story.
>
> Verdict is: DUP/SINGLE is a very serious fun stuff
> when used unknowingly. Small btrfs is such a case.
> And third party tools (ex: gparted) plays with it.
>
> Let's warn users with some documentation,
> together with "A formal small fs" behaviour..
I'm not sure about gparted, but the default behavior for mkfs is as follows:
1. Is the device rotational? (check /sys/block/<device>/rotational).  If 
not, do some extra stuff to try and ID it as an SSD.  If it is an SSD, 
use SINGLE mode for metadata, otherwise use DUP mode for metadata.
2. Is the FS set for mixed-bg?  If so, use the same profile for data as 
metadata, otherwise use SINGLE mode for data.

It would not surprise me if gparted switches to single metadata mode for 
a small enough FS, but I'm not certain.  I do think that they just use 
the default selection for mixed-bg though, which means not using it in 
current btrfs-progs versions.
