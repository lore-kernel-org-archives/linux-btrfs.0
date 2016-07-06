Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:33800 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbcGFJv1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 05:51:27 -0400
Received: by mail-qk0-f171.google.com with SMTP id t127so310283432qkf.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 02:51:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de> <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Wed, 6 Jul 2016 12:51:25 +0300
Message-ID: <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
Subject: Re: 64-btrfs.rules and degraded boot
To: Chris Murphy <lists@colorremedies.com>
Cc: Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 5, 2016 at 11:10 PM, Chris Murphy <lists@colorremedies.com> wrote:
> I started a systemd-devel@ thread since that's where most udev stuff
> gets talked about.
>
> https://lists.freedesktop.org/archives/systemd-devel/2016-July/037031.html
>

Before discussing how to implement it in systemd, we need to decide
what to implement. I.e.

1) do you always want to mount filesystem in degraded mode if not
enough devices are present or only if explicit hint is given?
2) do you want to restrict degrade handling to root only or to other
filesystems as well? Note that there could be more early boot
filesystems that absolutely need same treatment (enters separate
/usr), and there are also normal filesystems that may need be mounted
even degraded.
3) can we query btrfs whether it is mountable in degraded mode?
according to documentation, "btrfs device ready" (which udev builtin
follows) checks "if it has ALL of it’s devices in cache for mounting".
This is required for proper systemd ordering of services.
