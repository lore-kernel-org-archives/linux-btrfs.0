Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vc0-f180.google.com ([209.85.220.180]:42690 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924AbaIKPuB (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Sep 2014 11:50:01 -0400
Received: by mail-vc0-f180.google.com with SMTP id hq11so2253781vcb.11
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Sep 2014 08:50:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140911023525.GA9414@localhost.localdomain>
References: <CAFvQSYQBTViupkLThmaxXNQ8is1ohO-3+0E=wwwP1WdETtHz5w@mail.gmail.com>
	<20140911023525.GA9414@localhost.localdomain>
Date: Thu, 11 Sep 2014 17:50:00 +0200
Message-ID: <CAFvQSYR5s77xS0PFkOPeH0J-WnyGSo_-tMj2uE33-eeLMDAQfg@mail.gmail.com>
Subject: Re: Deadlock with 3.15.10
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Liu,

>> I've recently run into a deadlock on 3.15.10, don't know if the kernel
>> stack-trace is useful: http://pastebin.com/guQNDAMX
>
> FYI, this's been fixed by https://patchwork.kernel.org/patch/4727711/

Thanks for letting me know.

- Clemens
