Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:50214 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932190AbcIKUGm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 11 Sep 2016 16:06:42 -0400
Date: Sun, 11 Sep 2016 22:06:35 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Martin Steigerwald <martin@lichtvoll.de>
Cc: Steven Haigh <netwiz@crc.id.au>, linux-btrfs@vger.kernel.org
Subject: Re: compress=lzo safe to use? (was: Re: Trying to rescue my data :()
Message-ID: <20160911200635.GA19703@angband.pl>
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <pan$e8a2$15460093$3bb59e30$70ebaf89@cox.net>
 <21b8852b-fba6-6f8f-feed-7bbfa12312d2@crc.id.au>
 <4096253.hu8ZAHGEqT@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <4096253.hu8ZAHGEqT@merkaba>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 11, 2016 at 09:48:35PM +0200, Martin Steigerwald wrote:
> Hmm… I found this from being referred to by reading Debian wiki page on 
> BTRFS¹.
> 
> I use compress=lzo on BTRFS RAID 1 since April 2014 and I never found an 
> issue. Steven, your filesystem wasn´t RAID 1 but RAID 5 or 6?
> 
> I just want to assess whether using compress=lzo might be dangerous to use in 
> my setup. Actually right now I like to keep using it, since I think at least 
> one of the SSDs does not compress. And… well… /home and / where I use it are 
> both quite full already.
> 
> [1] https://wiki.debian.org/Btrfs#WARNINGS

I have used compress=lzo for years, kernels 3.8, 3.13 and 3.14 (a bunch of
machines), without a single glitch; heavy snapshotting, single dev only, no
quota.  Until recently I did never balanced.

I did have a case of ENOSPC with <80% full on 4.7 which might or might not
be related to compress=lzo.

-- 
Second "wet cat laying down on a powered-on box-less SoC on the desk" close
shave in a week.  Protect your ARMs, folks!
