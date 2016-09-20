Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:35861 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753994AbcITSTM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 14:19:12 -0400
Received: by mail-wm0-f41.google.com with SMTP id w84so149111482wmg.1
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 11:19:11 -0700 (PDT)
From: Alexandre Poux <pums974@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: multi-device btrfs with single data mode and disk failure
References: <1634818f-ff1d-722c-6d73-747ed7203a13@gmail.com>
 <CAJCQCtQHBkx8kjcAdSbmgYcHCo_w3VPj8jvgby3cE-S6rLAPdw@mail.gmail.com>
 <ecac8c64-8ed4-7c8d-29ad-5b3687981a33@gmail.com>
 <CAJCQCtSupa8LT+RK3=w3t7+T_nDcgUzzjSdfEi16DpiQxbm0hQ@mail.gmail.com>
 <760be1b7-79b2-a25d-7c60-04ceac1b6e40@gmail.com>
 <CAJCQCtR2t+3w6ovo88L0_2GqnVWveK5DNJ-vWdw18y+Sng4chQ@mail.gmail.com>
 <3460a1ac-7e66-cf6f-b229-06a0825401a5@gmail.com>
 <b880821f-bfb5-5265-53a4-213b22487ddb@gmail.com>
 <CAJCQCtRYpvnGurLSbxu2N0ELuvVKrM5w=jBkAneecaEog213dQ@mail.gmail.com>
Message-ID: <64102181-e02d-69a8-ead7-a27acadbe6a8@gmail.com>
Date: Tue, 20 Sep 2016 20:19:08 +0200
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRYpvnGurLSbxu2N0ELuvVKrM5w=jBkAneecaEog213dQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Le 20/09/2016 à 19:54, Chris Murphy a écrit :
> On Tue, Sep 20, 2016 at 11:03 AM, Alexandre Poux <pums974@gmail.com> wrote:
>
>> If I wanted to try to edit my partitions with an hex editor, where would
>> I find infos on how to do that ?
>> I really don't want to go this way, but if this is relatively simple, it
>> may be worth to try.
> Simple is relative. First you'd need
> https://btrfs.wiki.kernel.org/index.php/On-disk_Format to get some
> understanding of where things are to edit, and then btrfs-map-logical
> to convert btrfs logical addresses to physical device and sector to
> know what to edit.
>
> I'd call it distinctly non-trivial and very tedious.
>
OK, another idea:
would it be possible to trick btrfs with a manufactured file that the
disk is present while it isn't ?

I mean, looking for a few minutes on the hexdump of my trivial test
partition, header of members of btrfs array seems very alike.
So maybe, I can make a file wich would have enough header to make btrfs
believe that this is my device, and then remove it as usual....
looks like a long shot, but it doesn't hurt to ask....
