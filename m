Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:35573 "EHLO
	mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932624AbbIXRlW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Sep 2015 13:41:22 -0400
Received: by vkao3 with SMTP id o3so41428472vka.2
        for <linux-btrfs@vger.kernel.org>; Thu, 24 Sep 2015 10:41:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <560409E7.5020500@mur.at>
References: <560409E7.5020500@mur.at>
Date: Thu, 24 Sep 2015 11:41:21 -0600
Message-ID: <CAJCQCtQ3aSfHE3o4nyaKOJjDbxiw87GHW6_JdBC1vnDgQXgGKA@mail.gmail.com>
Subject: Re: strange i/o errors with btrfs on raid/lvm
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?Q?Jogi_Hofm=C3=BCller?= <jogi@mur.at>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Sep 24, 2015 at 8:34 AM, Jogi Hofmüller <jogi@mur.at> wrote:


> All this runs on a virtual machine that uses kernel 4.1.3 (Debian build)
> and btrfs-progs v4.0.

Unrelated to the problem but I'd upgrade progs, in case it's ever
needed. 4.1 and 4.2 have tons of bug fixes over 4.0 already.

>
> So finally I would ask what we can do to solve this problem?  I also
> appreciate comments to the situation and of course hints to what is
> going on.  This is over my head.

The problem description is incomplete without a dmesg. If this is a systemd
system, then I suggest
journalctl -b -l -o short-monotonic > journal.txt

Otherwise you can put in a trimmed /var/log/messages for the current boot.
I think it's best to have kernel messages for the entire boot because the
cause could be buried well before the Btrfs error messages.

Attach that to the mailing list. If it's too big, the best option is file a
bug, attach the file to the bug, and then post the URL for the bug in this
thread. The fallback is put it up somewhere else, the problem there is it
ends up being temporarily available so if someone runs into this thread in
a  year your attachment is MIA.



-- 
Chris Murphy
