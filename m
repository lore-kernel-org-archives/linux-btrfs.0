Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f178.google.com ([209.85.214.178]:63735 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759275Ab3DYVB7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 17:01:59 -0400
Received: by mail-ob0-f178.google.com with SMTP id 16so2964577obc.9
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2013 14:01:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130425203900.GL2631@localhost.localdomain>
References: <CAG42UxdVpz7a0FPEc7Ajm+jHHrqG7zT2=JaPZcFzMQT18eqzww@mail.gmail.com>
 <20130417065506.GA21083@panda> <CAG42Uxcjk-T9e-9uO6L+dLzqo3N7c+RMvUyaS2WE_aFWK9niJA@mail.gmail.com>
 <CAG42Uxccx7NzJN2oyyAqU9mWN8q-6==V2zg1OQ2mOfvBZtbs1w@mail.gmail.com>
 <20130418215856.GA2305@localhost.localdomain> <CAG42Uxeajo=RESm531A7WWtFzKsFVDRJXuve1BRQXFPceFTMgw@mail.gmail.com>
 <20130425203900.GL2631@localhost.localdomain>
From: Matt Pursley <mpursley@gmail.com>
Date: Thu, 25 Apr 2013 14:01:18 -0700
Message-ID: <CAG42UxcVhXT5=kgUedAWDbSnPuW_Nu---PsG+WRuNCFn9Kdeng@mail.gmail.com>
Subject: Re: One random read streaming is fast (~1200MB/s), but two or more
 are slower (~750MB/s)?
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Ok, awesome, let me know how it goes..  I don't have the raid
formatted to btrfs right now, but I could probably do that in about 30
minutes or so.


Thanks Josef,
Matt




On Thu, Apr 25, 2013 at 1:39 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Thu, Apr 25, 2013 at 01:52:44PM -0600, Matt Pursley wrote:
>> Hey Josef,
>>
>> Were you able to look into this any further?
>> It's still pretty reproducible on my machine...
>>
>
> Nope I've been tracking down random problems, I'll try it now.  Thanks,
>
> Josef
