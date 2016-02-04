Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f175.google.com ([209.85.213.175]:36268 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965095AbcBDUkf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Feb 2016 15:40:35 -0500
Received: by mail-ig0-f175.google.com with SMTP id xg9so34398124igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Feb 2016 12:40:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56B3B24C.8070200@gmail.com>
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
	<56B2AA51.80908@cn.fujitsu.com>
	<CAM=f9=X5BU0N4iueXtVf4y5SAxrnMQgtgbrsx0Gbc8W6SEspMg@mail.gmail.com>
	<1724218.nF6PTv1Cei@merkaba>
	<56B349BE.30003@gmail.com>
	<CAJCQCtTYFeM-ryJbFHfsiPEK+xbwkNoAmZ1=k8eaJ5TnS7yLaQ@mail.gmail.com>
	<56B3B24C.8070200@gmail.com>
Date: Thu, 4 Feb 2016 21:40:34 +0100
Message-ID: <CAM=f9=XZ+=QAmjiXj2Nm2xveb5sTcVTM=a3TQVRDXmpJsrQrdg@mail.gmail.com>
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
From: Moviuro <moviuro@gmail.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 4, 2016 at 9:28 PM Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:
>
> On 2016-02-04 14:40, Chris Murphy wrote:
> > On Thu, Feb 4, 2016 at 5:53 AM, Austin S. Hemmelgarn
> > <ahferroin7@gmail.com> wrote:
> >
> >
> >> 4) Possibly get rid of the message on subvolume delete (It provides no
> >> useful information at all, and it has no option to not error out on non
> >> existence of a subvolume.  In addition, the same arguments as for create
> >> apply here too.).
> >
> > btrfs sub del has different commit modes that affect the user space
> > command's completion behavior, and output. So I wouldn't say it isn't
> > useful.
> >
> Last I checked, those are controlled by using command line switches,
> which means that anyone invoking them knows what they're invoking
> because it's specified on the command line, therefore all info it
> currently provides in the non-error case is info you should already
> have.  I have no issue with it spitting out errors if something goes
> wrong, but it's just annoying having output that provides no information
> that isn't already known when everything goes right (think atd, cron,
> and almost any other periodic or deferred scheduling system).

OK, so let's put our thinking into words.
But where do we start? the ML won't be a good place to do that IMHO.
Something like github may be easier to contribute to, and since it
won't be any real code at first, it shouldn't be a problem using a
platform like that, right? https://github.com/btrfs8-revamp
If you don't find that to be a good choice, I'm open to alternatives.
