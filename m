Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f43.google.com ([209.85.219.43]:56693 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab3DZXWG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 19:22:06 -0400
Received: by mail-oa0-f43.google.com with SMTP id k7so4499677oag.30
        for <linux-btrfs@vger.kernel.org>; Fri, 26 Apr 2013 16:22:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130425211019.GM2631@localhost.localdomain>
References: <CAG42UxdVpz7a0FPEc7Ajm+jHHrqG7zT2=JaPZcFzMQT18eqzww@mail.gmail.com>
 <20130417065506.GA21083@panda> <CAG42Uxcjk-T9e-9uO6L+dLzqo3N7c+RMvUyaS2WE_aFWK9niJA@mail.gmail.com>
 <CAG42Uxccx7NzJN2oyyAqU9mWN8q-6==V2zg1OQ2mOfvBZtbs1w@mail.gmail.com>
 <20130418215856.GA2305@localhost.localdomain> <CAG42Uxeajo=RESm531A7WWtFzKsFVDRJXuve1BRQXFPceFTMgw@mail.gmail.com>
 <20130425203900.GL2631@localhost.localdomain> <CAG42UxcVhXT5=kgUedAWDbSnPuW_Nu---PsG+WRuNCFn9Kdeng@mail.gmail.com>
 <20130425211019.GM2631@localhost.localdomain>
From: Matt Pursley <mpursley@gmail.com>
Date: Fri, 26 Apr 2013 16:21:24 -0700
Message-ID: <CAG42UxfctrmBK_rgVSusjQX8ur_6u_QgA1LGhRV-UW=WT8gTsA@mail.gmail.com>
Subject: Re: One random read streaming is fast (~1200MB/s), but two or more
 are slower (~750MB/s)?
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Josef,

Thanks for looking into this further!    That is about the same
results that I was seeing, though I didn't test it with just one
drive.. only with all 12 drives in my jbod.  I will do a test with
just one disk, and see if I also get the same results.

Let me know if you also see the same results with multiple drives in
your raid...


Thanks,
Matt





On Thu, Apr 25, 2013 at 2:10 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Thu, Apr 25, 2013 at 03:01:18PM -0600, Matt Pursley wrote:
>> Ok, awesome, let me know how it goes..  I don't have the raid
>> formatted to btrfs right now, but I could probably do that in about 30
>> minutes or so.
>>
>
> Huh so I'm getting the full bandwidth, 120 mb/s with one thread and 60 mb/s with
> two threads.  These are just cheap sata drives tho, I'll try and dig up a box
> with 3 fusion cards for something a little closer to the speeds you are seeing
> and see if that makes a difference.  Thanks,
>
> Josef
