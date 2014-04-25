Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:55392 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaDYKnM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 06:43:12 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Cc: George Eleftheriou <eleftg@gmail.com>
Subject: Re: how to cancel scrub which got aborted due to hardly switching off the machine?
Date: Fri, 25 Apr 2014 12:42:29 +0200
Message-ID: <1519236.OmuO3RK8qv@merkaba>
In-Reply-To: <CAPpBBdPMUKDnvpx0O_eCZxbAcjd1AMspWk1piyASBbZyyeNwWw@mail.gmail.com>
References: <12598280.ebLKYkuoEp@merkaba> <CAPpBBdPMUKDnvpx0O_eCZxbAcjd1AMspWk1piyASBbZyyeNwWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 25. April 2014, 11:40:28 schrieben Sie:

> On Fri, Apr 18, 2014 at 7:18 PM, Martin Steigerwald <Martin@lichtvoll.de> 
wrote:
> > Hello,
> > 
> > I have:
> > 
> > merkaba:/mnt#1> btrfs scrub status -d /home
> > scrub status for […]
> > scrub device /dev/dm-0 (id 1) status
> > 
> >         scrub started at Fri Apr 18 17:48:10 2014, running for 335 seconds
> >         total bytes scrubbed: 74.80GiB with 0 errors
[… cannot cancel or resume an aborted scrub …]

> rm /var/lib/btrfs/scrub-<bla-bla-bla-bla>

Thanks, works like a charm.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
