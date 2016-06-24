Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33254 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966AbcFXFev (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jun 2016 01:34:51 -0400
Received: by mail-oi0-f41.google.com with SMTP id u201so101744226oie.0
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jun 2016 22:34:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$4aafc$8178c223$638252a3$717a5f23@cox.net>
References: <loom.20160623T205347-371@post.gmane.org> <CAJCQCtRO+FYrsfHF_ARSnPfoS7uzvLR4hB1V-TJ_YN4NcA6srw@mail.gmail.com>
 <pan$4aafc$8178c223$638252a3$717a5f23@cox.net>
From: Chris Murphy <lists@colorremedies.com>
Date: Thu, 23 Jun 2016 23:34:49 -0600
Message-ID: <CAJCQCtQAXydm65n1P_YNF2r5EJmPYk6a2Q+x38zGzpLsagCgyg@mail.gmail.com>
Subject: Re: Bad hard drive - checksum verify failure forces readonly mount
To: Duncan <1i5t5.duncan@cox.net>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2016 at 10:56 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Chris Murphy posted on Thu, 23 Jun 2016 18:54:28 -0600 as excerpted:
>
>> From the pasted kernel messages:
>>
>>> Linux version 3.18.34-std473-amd64 (root@rl-sysrcd-p11) (gcc version
>>> 4.8.5 (Gentoo 4.8.5 p1.3, pie-0.6.2) ) #2 SMP Tue May 24 20:34:19 UTC
>>> 2016
>>
>>
>> 3.18.34 is ancient. Find something newer and try to remount normally.
>> And then also with recovery if necessary (don't use ro, see if it'll
>> mount rw and fix itself). And if not, then try btrfs check with a newer
>> version of btrfs-progs, I can't tell from the pasted output what version
>> you're using but since the kernel is so old, decent chance the btrfsck
>> is old also.
>
> ...  So I guess that means we're back to supporting only the latest two
> LTS kernel series, those being 4.1 and 4.4 at this time.  I had hoped
> that btrfs was stabilizing enough, and 3.18 was trouble-free enough btrfs-
> wise, that we could expand that to three LTS series now, as the
> indications were we might when 4.4 was still new.  But it seems that
> while we did support it a bit longer, say 2.5 LTS series, that couldn't
> continue until the /next/ LTS came out.
>
> Oh, well, it /was/ a bit of a stretch...

Yeah looks like 3.18.35 even has some backports, and it's not that old
but I have no idea if the problem in this case if fixed by something
newer.

I'd say 50/50 shot at a new kernel doing better, but for the sure the
btrfs-progs has a better chance because btrfsck has had lots of
improvements since 3.18. It's just too easy to dd a Fedora 24 live
image to a USB stick, which has kernel 4.5.5 and btrfs-progs 4.5.2 and
give it a shot. And if that doesn't work, then btrfs-image time so
hopefully devs can see if it's possible to improve btrfsck. But at
that point it also means blowing away this fs :-\ but at least it's ro
mountable so anything important can be copied off normally.

-- 
Chris Murphy
