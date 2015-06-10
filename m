Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:34782 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbbFJIsO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Jun 2015 04:48:14 -0400
Received: by lbcmx3 with SMTP id mx3so24430553lbc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Jun 2015 01:48:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5577EB9A.2030707@cn.fujitsu.com>
References: <CAFQiR=S6uSkuC1rvh4coPMSr8AtewMLF8xejEfBdC45iYoqsKw@mail.gmail.com>
 <5577EB9A.2030707@cn.fujitsu.com>
From: Federico Pedemonte <pedemonte@gmail.com>
Date: Wed, 10 Jun 2015 10:47:42 +0200
Message-ID: <CAFQiR=RCtST1HgB3QtnxS5EwyeT4rDu_OYyZWGUW67f-wZg=eQ@mail.gmail.com>
Subject: Re: SSD mode on hybrid disk (SSHD)
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 10, 2015 at 9:47 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
> Hi,
>
> You can try nossd mount option (mount DEV MNT -o nossd), which will disable
> ssd related optimization.

thanks Qu!

I've tried it, but the disk still seems slow as hell.

> But according to my experience, even enable ssd mode on HDD, performance
> shouldn't drop too much, and sometimes, especially random write performance
> will even improve hugely.(but at cost of more fragments).

hum... ok!

so probably there are different issues to look at

thanks for your reply!

regards,
Federico
