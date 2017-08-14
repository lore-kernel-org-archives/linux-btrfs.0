Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f170.google.com ([209.85.217.170]:38569 "EHLO
        mail-ua0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752500AbdHNH7l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 Aug 2017 03:59:41 -0400
Received: by mail-ua0-f170.google.com with SMTP id w45so33883548uac.5
        for <linux-btrfs@vger.kernel.org>; Mon, 14 Aug 2017 00:59:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN4oSBdO8GfBQA1CrLVa1atA+QJquCy63KBqOHhh49Uz=1sgjQ@mail.gmail.com>
References: <CAN4oSBdO8GfBQA1CrLVa1atA+QJquCy63KBqOHhh49Uz=1sgjQ@mail.gmail.com>
From: "Lakshmipathi.G" <lakshmipathi.g@gmail.com>
Date: Mon, 14 Aug 2017 13:28:59 +0530
Message-ID: <CAKuJGC-O8ws3tp0=dhfi6RW27d+hgpb9pw8vdV24P7cxQPw8LA@mail.gmail.com>
Subject: Re: Building a BTRFS test machine
To: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Cc: btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Definitely it will be useful.  For quite sometime, I was thinking about:
1. Creating test cases for each BTRFS features. (ex:
https://btrfs.wiki.kernel.org/index.php/Scrub_corruption_cases)
2. Automate these  feature specific test scripts using bash/python
while maintaining them in public git repos.
3. Launching BTRFS test machines in cloud (aws spot instance are very cheap) .
4. Run those feature specific tests and publish the results into wiki
or/and bugs into bugzilla.
5. Destroy the test machines.

Such setup will require quite good effort. As Qu mentioned, the
challenging part will be integrating existing different tests and make
it automatic.

Another thought on BTRFS testing:
At this moment, when someone sends a patch - i assume, they
automatically pushed into patchwork.kernel.org (based on some back-end
configuration I guess).

On Btrfs mailing-list,we have lot of bug reports so using something
like [1] we can write a
program which parses mailing-list for specific keyword like
"BUGREPORT:<bug description>" similar to "PATCH:<patch description>"
and create a new
bug or update the details on bugzilla.kernel.org? This will ensure we
can keep track of bugs on
bugzilla.

I think updating bugs based on mailing-list responses will be little
tricky than creating new bugs.
something like that can be useful as well.

I can help a bit on such testbed setup  :-) Thanks!

----
Cheers,
Lakshmipathi.G
http://www.giis.co.in http://www.webminal.org


On Mon, Aug 14, 2017 at 6:31 AM, Cerem Cem ASLAN <ceremcem@ceremcem.net> wrote:
> Would that be useful to build a BTRFS test machine, which will perform
> both software tests (btrfs send | btrfs receive, read/write random
> data etc.) and hardware tests, such as abrupt power off test, abruptly
> removing a raid-X disk physically, etc.
>
> If it would be useful, what tests should it cover?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
