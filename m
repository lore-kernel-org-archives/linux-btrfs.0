Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:53640 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaK1PCn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Nov 2014 10:02:43 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so18809429wiw.13
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Nov 2014 07:02:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5474F5D1.2070908@ubuntu.com>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
	<546AF572.2020101@swiftspirit.co.za>
	<20141118153526.GS20972@merlins.org>
	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>
	<546BB2EA.5080809@ubuntu.com>
	<E47EA20E-375D-49A6-B4B0-C6594CE6A633@colorremedies.com>
	<546CB332.3080705@ubuntu.com>
	<CAJCQCtTfhxW2w+mT6rqyr+WwVdj8SAEAGV+LB8_S3mcw0agxaw@mail.gmail.com>
	<5474F5D1.2070908@ubuntu.com>
Date: Fri, 28 Nov 2014 16:02:41 +0100
Message-ID: <CAA7pwKNOxZ=pg_uJ2iO67xo-=aWqNikbQKJPT5QOxEi2av1sRA@mail.gmail.com>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: Phillip Susi <psusi@ubuntu.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25 November 2014 at 22:34, Phillip Susi <psusi@ubuntu.com> wrote:
> On 11/19/2014 7:05 PM, Chris Murphy wrote:
> > I'm not a hard drive engineer, so I can't argue either point. But
> > consumer drives clearly do behave this way. On Linux, the kernel's
> > default 30 second command timer eventually results in what look
> > like link errors rather than drive read errors. And instead of the
> > problems being fixed with the normal md and btrfs recovery
> > mechanisms, the errors simply get worse and eventually there's data
> > loss. Exhibits A, B, C, D - the linux-raid list is full to the brim
> > of such reports and their solution.
>
> I have seen plenty of error logs of people with drives that do
> properly give up and return an error instead of timing out so I get
> the feeling that most drives are properly behaved.  Is there a
> particular make/model of drive that is known to exhibit this silly
> behavior?

I had a couple of Seagate Barracuda 7200.11 (codename Moose) drives
with seriously retarded firmware.

They never reported a read error AFAIK but began to time out instead.
They wouldn't even respond after a link reset. I had to power cycle
the disks.

Funny days with ddrescue. Got almost everything off them.
