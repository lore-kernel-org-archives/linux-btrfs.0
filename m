Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:45178 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051AbaK3K10 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 05:27:26 -0500
Received: by mail-qc0-f175.google.com with SMTP id b13so7175707qcw.6
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 02:27:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141130042123.GD8916@merlins.org>
References: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com>
 <20141130042123.GD8916@merlins.org>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Sun, 30 Nov 2014 15:57:06 +0530
Message-ID: <CAH-HCWW9LQgTc-rhfbbLJBvGu7uCAFiTr_VJ0c=H_ZjYjDW5gA@mail.gmail.com>
Subject: Re: Moving an entire subvol?
To: Marc MERLIN <marc@merlins.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 30, 2014 at 9:51 AM, Marc MERLIN <marc@merlins.org> wrote:
>
>> So the Ubuntu Wiki BtrFS entry advises against using subvol
>> set-default because it boots its kernel using root=subvol=@ and home
>> as subvol=@home, and these two subvols are only present under the
>> subvol with ID 5. But isn't it just possible to move i.e. reparent a
>> subvol so I can move these two under another subvol and have that as
>> default?
>
> Make a new subvolume called /root and just mount subvol=root

Sorry if my question wasn't clear: I wanted to know how to move a
subvol to appear under another subvol other than its original parent.
Turns out that sudo mv @ @home target/ is quite sufficient. If so why
would the Ubuntu wiki require that set-default not be used? Just @
@home need to be moved to the new place, no?

> Note that you can't mount subvols recursively in one mount AFAIK.

I'm not sure what you mean. I have a few subvols in my external HDD
which is entirely formatted as BtrFS and if I just mount the external
HDD /dev/sdc1 I am able to access all the subvols' contents as well.

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
