Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:37549 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbcDFD6m (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Apr 2016 23:58:42 -0400
Received: by mail-wm0-f42.google.com with SMTP id n3so45401556wmn.0
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Apr 2016 20:58:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR60t=XN1vXaRoMA_YBAy=jje6ns9EoUO1wG_+Zk02LZw@mail.gmail.com>
References: <CAD=QJKi-3PJQViAaRmGoz3_w6RQbRehDL9vXs14+CSHsG3ipTg@mail.gmail.com>
	<CAD=QJKg6xFSFjJdDyD+v0Rd2afeB-ZRRy2SncC1Db5fyT3cf9A@mail.gmail.com>
	<20160310023627.2e915667@natsu>
	<pan$9dde$acf9ba51$bb837cb8$8c954a04@cox.net>
	<CAD=QJKjkzh4U5Gmp=PJMiR8w3by12BVCDZ+MN2S+Ekk_EksjAg@mail.gmail.com>
	<CAD=QJKi7=R92UP4PKH4UAYH1HUB0Pr8DwO+MsyLNamKryYuZVA@mail.gmail.com>
	<CAJCQCtR60t=XN1vXaRoMA_YBAy=jje6ns9EoUO1wG_+Zk02LZw@mail.gmail.com>
Date: Tue, 5 Apr 2016 23:58:41 -0400
Message-ID: <CAD=QJKgrBXCXjP4vEzsGtO9oYN7LQ1titFatCYhmLbZea8_W0w@mail.gmail.com>
Subject: Re: dstat shows unexpected result for two disk RAID1
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11 March 2016 at 20:20, Chris Murphy <lists@colorremedies.com> wrote:
> On Fri, Mar 11, 2016 at 5:10 PM, Nicholas D Steeves <nsteeves@gmail.com> wrote:
>> P.S. Rather than parity, I mean instead of distributing into stripes, do a copy!
>
> raid56 by definition are parity based, so I'd say no that's confusing
> to turn it into something it's not.

I just found the Multiple Device Support diagram.  I'm trying to
figure out how hard it's going for me to get up to speed, because I've
only ever casually and informally read about filesystems.  I worry
that because I didn't study filesystem design in school, and because
everything I worked on was in C++...well, the level of sophistication
and design might be beyond what I can learn.  What do you think?  Can
you recommend any books on file system design that will provide what
is necessary to understand btrfs?

Cheers,
Nicholas
