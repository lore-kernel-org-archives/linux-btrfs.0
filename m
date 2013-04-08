Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:35905 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783Ab3DHLTg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2013 07:19:36 -0400
Received: by mail-la0-f46.google.com with SMTP id fq12so5258051lab.19
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Apr 2013 04:19:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130408171443.5339e82f@natsu>
References: <CAFWF=ameE9p4W5XT-yLoU2H=by0Y4yp3VUmiLOXSOtOzBHaYwQ@mail.gmail.com>
 <20130408171443.5339e82f@natsu>
From: Harald Glatt <mail@hachre.de>
Date: Mon, 8 Apr 2013 13:19:13 +0200
Message-ID: <CAFWF=am5sBw+APOu6yAUBnjvpt+vbr_7vw0F8o1ZAGk-JDbhmg@mail.gmail.com>
Subject: Re: btrfs can't complete balance
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You're right, I'm seeing this 'object already exists' message in my
dmesg log. Nice catch!!

I'm posting it again in case others missed it too, this was the kernel
panic dmesg that happened during the balance that I did in order to
fix the 'btrfs send' not working anymore problem:
http://pastebin.com/3QZqrqAX

On Mon, Apr 8, 2013 at 1:14 PM, Roman Mamedov <rm@romanrm.ru> wrote:
> On Mon, 8 Apr 2013 09:48:55 +0200
> Harald Glatt <mail@hachre.de> wrote:
>
>> At some point 'btrfs send' stopped working but gave no better error
>> message than invalid argument.
>
> Usually in cases like this there are more details in 'dmesg'.
>
>> I did a balance on the drive which resulted in a kernel panic after a
>> while of working.
>
> Maybe you faced the same problem that I had recently with "Object already
> exists" . Could've been useful if you saved the actual kernel panic message.
>
> --
> With respect,
> Roman
