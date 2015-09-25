Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f53.google.com ([209.85.215.53]:33146 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295AbbIYOC7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 10:02:59 -0400
Received: by lahh2 with SMTP id h2so98051639lah.0
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 07:02:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5605518B.2020103@jrs-s.net>
References: <55F88ECC.1040604@menke.ac> <55FE0B42.50300@jrs-s.net>
 <CAGfcS_=bst0S8YLsr6y4oGDu7Gy-ox9ow5+_nD4c3zFdj-Y6ug@mail.gmail.com>
 <56054665.1020608@gmail.com> <5605518B.2020103@jrs-s.net>
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Fri, 25 Sep 2015 17:02:18 +0300
Message-ID: <CAGqmi75-Wc-YOwCJhRD1ahgKhEM5tPPBVjCYmvgjMZNhEnk77w@mail.gmail.com>
Subject: Re: BTRFS as image store for KVM?
To: Jim Salter <jim@jrs-s.net>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        Rich Freeman <r-btrfs@thefreemanclan.net>, Gert Menke <gert@menke.ac>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2015-09-25 16:52 GMT+03:00 Jim Salter <jim@jrs-s.net>:
> Pretty much bog-standard, as ZFS goes.  Nothing different than what's
> recommended for any generic ZFS use.
>
> * set blocksize to match hardware blocksize - 4K drives get 4K blocksize, 8K
> drives get 8K blocksize (Samsung SSDs)
> * LZO compression is a win.  But it's not like anything sucks without it.
> No real impact on performance for most use, + or -. Just saves space.
> * > 4GB allocated to the ARC.  General rule of thumb: half the RAM belongs
> to the host (which is mostly ARC), half belongs to the guests.
>
> I strongly prefer pool-of-mirrors topology, but nothing crazy happens if you
> use striped-with-parity instead.  I use to use RAIDZ1 (the rough equivalent
> of RAID5) quite frequently, and there wasn't anything amazingly sucky about
> it; it performed at least as well as you'd expect ext4 on mdraid5 to
> perform.
>
> ZFS might or might not do a better job of managing fragmentation; I really
> don't know.  I strongly suspect the design difference between the kernel's
> simple FIFO page cache and ZFS' weighted cache makes a really, really big
> difference.
>
>
>
> On 09/25/2015 09:04 AM, Austin S Hemmelgarn wrote:
>> you really need to give specifics on how you have ZFS set up in that case.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

FYI:
Linux pagecache use LRU cache algo, and in general case it's working good enough

-- 
Have a nice day,
Timofey.
