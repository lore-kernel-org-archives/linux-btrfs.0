Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:53594 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934384Ab3DHLXh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Apr 2013 07:23:37 -0400
Received: by mail-lb0-f172.google.com with SMTP id u10so5614916lbi.31
        for <linux-btrfs@vger.kernel.org>; Mon, 08 Apr 2013 04:23:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130408172200.19f003ca@natsu>
References: <CAFWF=ameE9p4W5XT-yLoU2H=by0Y4yp3VUmiLOXSOtOzBHaYwQ@mail.gmail.com>
 <20130408171443.5339e82f@natsu> <CAFWF=am5sBw+APOu6yAUBnjvpt+vbr_7vw0F8o1ZAGk-JDbhmg@mail.gmail.com>
 <20130408172200.19f003ca@natsu>
From: Harald Glatt <mail@hachre.de>
Date: Mon, 8 Apr 2013 13:23:15 +0200
Message-ID: <CAFWF=an8JH+=mFPAPfg_kfyPop_AWG0aNdSPX0MOZ9XO9Gs0EA@mail.gmail.com>
Subject: Re: btrfs can't complete balance
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That's not gonna be a problem, I'm always running on the most recent
final kernel - in the case of my panic it was 3.8.6. Thanks!

On Mon, Apr 8, 2013 at 1:22 PM, Roman Mamedov <rm@romanrm.ru> wrote:
> On Mon, 8 Apr 2013 13:19:13 +0200
> Harald Glatt <mail@hachre.de> wrote:
>
>> You're right, I'm seeing this 'object already exists' message in my
>> dmesg log. Nice catch!!
>
> See this thread:
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg23514.html
>
> This patch fixes the problem:
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg23534.html
>
> But it is / will be only in the very latest kernels (including 'stable'
> updates), because it was posted only like a week ago.
>
> --
> With respect,
> Roman
