Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:42248 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759156Ab3DYTxZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Apr 2013 15:53:25 -0400
Received: by mail-ob0-f175.google.com with SMTP id wp18so2841164obc.20
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Apr 2013 12:53:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130418215856.GA2305@localhost.localdomain>
References: <CAG42UxdVpz7a0FPEc7Ajm+jHHrqG7zT2=JaPZcFzMQT18eqzww@mail.gmail.com>
 <20130417065506.GA21083@panda> <CAG42Uxcjk-T9e-9uO6L+dLzqo3N7c+RMvUyaS2WE_aFWK9niJA@mail.gmail.com>
 <CAG42Uxccx7NzJN2oyyAqU9mWN8q-6==V2zg1OQ2mOfvBZtbs1w@mail.gmail.com> <20130418215856.GA2305@localhost.localdomain>
From: Matt Pursley <mpursley@gmail.com>
Date: Thu, 25 Apr 2013 12:52:44 -0700
Message-ID: <CAG42Uxeajo=RESm531A7WWtFzKsFVDRJXuve1BRQXFPceFTMgw@mail.gmail.com>
Subject: Re: One random read streaming is fast (~1200MB/s), but two or more
 are slower (~750MB/s)?
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Josef,

Were you able to look into this any further?
It's still pretty reproducible on my machine...


Thanks,
Matt





On Thu, Apr 18, 2013 at 2:58 PM, Josef Bacik <jbacik@fusionio.com> wrote:

> This is strange, and I can't see any reason why this would happen.  I'll try and
> reproduce next week when I'm back from LSF.  Thanks,
>
> Josef
