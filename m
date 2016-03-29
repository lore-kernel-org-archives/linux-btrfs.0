Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34443 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435AbcC2V0L (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Mar 2016 17:26:11 -0400
Received: by mail-lb0-f175.google.com with SMTP id vo2so19410212lbb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Mar 2016 14:26:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT7VD2r-gHBCDgCcicSgfhgFLQy-DXgWGGm4c76wtFTHQ@mail.gmail.com>
References: <CAHaDNyXRW4FQC+5P2_8apdFan2wtsHnPyzuK5ZPq8dLXW-S9_g@mail.gmail.com>
 <CAJCQCtT7VD2r-gHBCDgCcicSgfhgFLQy-DXgWGGm4c76wtFTHQ@mail.gmail.com>
From: Patrik Lundquist <patrik.lundquist@gmail.com>
Date: Tue, 29 Mar 2016 23:25:50 +0200
Message-ID: <CAA7pwKOkRy+tTs+83cXp=EZEoAhdKQrfpWDes0Gd5aKcpn_kZQ@mail.gmail.com>
Subject: Re: attempt to mount after crash during rebalance hard crashes server
To: Chris Murphy <lists@colorremedies.com>
Cc: "Warren, Daniel" <daniel.warren@mcmcllc.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 29 March 2016 at 22:46, Chris Murphy <lists@colorremedies.com> wrote:
> On Tue, Mar 29, 2016 at 2:21 PM, Warren, Daniel
> <daniel.warren@mcmcllc.com> wrote:
>> Greetings all,
>>
>> I'm running 4.4.0 from deb sid
>>
>> btrfs fi sh http://pastebin.com/QLTqSU8L
>> kernel panic http://pastebin.com/aBF6XmzA
>
> Panic shows:
> CPU: 0 PID: 153 Comm: kworker/u8:13 Not tainted 3.16-2-amd64 #1 Debian 3.16.3-2

That kernel is from 2014-09-20, long before even Jessie was released.

Current Sid is 4.4.6.
