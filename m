Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:35619 "EHLO
        mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756632AbcH2Mnb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 29 Aug 2016 08:43:31 -0400
Received: by mail-lf0-f49.google.com with SMTP id f93so99837051lfi.2
        for <linux-btrfs@vger.kernel.org>; Mon, 29 Aug 2016 05:42:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <SY3PR01MB13867F23DA1E0590A181CC5D9EE10@SY3PR01MB1386.ausprd01.prod.outlook.com>
References: <47ee55de-a77b-185a-1a01-b8b39899b188@profihost.ag>
 <0fa90a35-587e-7bfc-9418-ea8416b8f02e@cn.fujitsu.com> <f3a27bf7-fecd-e295-991a-8b69c3b92f12@profihost.ag>
 <CAK5rZE6-JKpNEo2zf8jmHqNTPZcPNSMNRJhb9Lbntn11=tzbmA@mail.gmail.com> <SY3PR01MB13867F23DA1E0590A181CC5D9EE10@SY3PR01MB1386.ausprd01.prod.outlook.com>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Mon, 29 Aug 2016 15:42:15 +0300
Message-ID: <CAK5rZE7fAbR3S=YbVxOc0vcLh7eWgHYhKkT3QxmoffThkO29Uw@mail.gmail.com>
Subject: Re: btrfs and systemd
To: Paul Jones <paul@pauljones.id.au>
Cc: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> Why not just create a Systemd unit (or whatever the proper term is) that
> runs on boot and runs the mount command manually and doesn't wait for it to
> return? Seems easier than messing with init systems.

Exactly: Never "mess" with inits..
