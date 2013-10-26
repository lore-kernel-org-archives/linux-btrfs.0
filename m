Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:43400 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab3JZHVe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 03:21:34 -0400
From: Alexandre Oliva <oliva@gnu.org>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid5
References: <0833228b-7a17-49f8-836a-2565a6b9af0c@aliyun.com>
	<pan$59a02$8231ca78$f5d54bfb$30812437@cox.net>
	<or7gd59qcf.fsf@livre.home> <5266B87D.9080202@swiftspirit.co.za>
	<ory55l85xm.fsf@livre.home>
	<pan$8e391$f46eecbc$498ef5f9$8d48b882@cox.net>
Date: Sat, 26 Oct 2013 05:21:17 -0200
In-Reply-To: <pan$8e391$f46eecbc$498ef5f9$8d48b882@cox.net> (Duncan's message
	of "Wed, 23 Oct 2013 00:50:51 +0000 (UTC)")
Message-ID: <orob6c7b0y.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Oct 22, 2013, Duncan <1i5t5.duncan@cox.net> wrote:

> the quick failure should they try raid56 in its current state simply
> alerts them to the problem they already had.

What quick failure?  There's no such thing in place AFAIK.  It seems to
do all the work properly, the limitations in the current implementation
will only show up when an I/O error kicks in.  I can't see any
indication, in existing announcements, that recovery from I/O errors in
raid56 is missing, let alone that it's so utterly and completely broken
that it will freeze the entire filesystem and require a forced reboot to
unmount the filesystem and make any other data in it accessible again.

That's far, far worse than the general state of btrfs, and that's not a
documented limitation of raid56, so how would someone be expected to
know about it?  It certainly isn't obvious by having a cursory look at
the code either.

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
