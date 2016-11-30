Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:58633 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1752603AbcK3CNz (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 29 Nov 2016 21:13:55 -0500
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1cBuP5-0002eV-9Z
        for linux-btrfs@vger.kernel.org; Wed, 30 Nov 2016 03:13:47 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: True size of btrfs data chunk
Date: Wed, 30 Nov 2016 02:13:38 +0000 (UTC)
Message-ID: <pan$b11a5$ec6d0e80$982b9cb0$a4cf188b@cox.net>
References: <CAGqmi74qK2v0JCtAjan8aju+sK3LWPWwMgnJOP3i2srrqnLHSA@mail.gmail.com>
        <44a745cd-ebb0-e62b-371c-8a37edd951fb@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Austin S. Hemmelgarn posted on Tue, 29 Nov 2016 09:58:50 -0500 as
excerpted:

> On 2016-11-29 09:32, Timofey Titovets wrote:
>> Hi, as wiki say https://btrfs.wiki.kernel.org/index.php/Glossary:

Bad link.  Without the terminating colon it works, however.

https://btrfs.wiki.kernel.org/index.php/Glossary

>> A part of a block group. Chunks are either 1 GiB in size (for data) or
>> 256 MiB (for metadata).

> This is only about the normal case.  Chunks are variable in size.  In
> most cases, data chunks will be 1GB and metadata 256MB.  They will
> however be smaller if there isn't enough space left for a full chunk,
> and will get larger as well once you get past a certain filesystem size
> (I don't remember the exact size, but I've seen people talking about big
> (double digit TB sized) filesystems with 5GB+ sized data chunks).

Yes.  The wiki is correct about the _nominal_ size, but it doesn't say 
"nominal", making the overall claim invalid.

If I had a wiki account I'd probably change it right now, but for 
personal reasons I don't fully understand myself, I seem to treat web 
pages, including wikis I could in theory edit, as read-only, even if the 
alternative is replying repeatedly to list threads such as this, vs. a 
single wiki edit.  [shrug]

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

