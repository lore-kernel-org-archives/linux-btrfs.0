Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.17.10]:65059 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbbIRI71 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Sep 2015 04:59:27 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Fri, 18 Sep 2015 10:59:23 +0200
From: Gert Menke <gert@menke.ac>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: BTRFS as image store for KVM?
In-Reply-To: <pan$8e5ba$d0b208e1$ccdbec8$531e48c2@cox.net>
References: <55F88ECC.1040604@menke.ac>
 <pan$a7c37$760f233d$6b18271c$f9ac2029@cox.net> <55FAFEB8.6030404@menke.ac>
 <20150917194314.GA29926@carfax.org.uk>
 <pan$8e5ba$d0b208e1$ccdbec8$531e48c2@cox.net>
Message-ID: <0d880a3285ee178de0ec1424157b85e0@durkon.lan>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-09-18 04:22, Duncan wrote:
> one way or another, you're going to
> have to write two things, one a checksum of the other, and if they are 
> in-
> place-overwrites, while the race can be narrowed, there's always going 
> to
> be a point at which either one or the other will have been written, 
> while
> the other hasn't been, and if failure occurs at that point...

...then you still can recover the old data from the mirror or parity, 
and at least you don't have any inconsistent data. It's like the failure 
occurred just a tiny bit earlier.

> The only real way around that is /some/ form of copy-on-write, such 
> that
> both the change and its checksum can be written to a different location
> than the old version, with a single, atomic write then updating a 
> pointer
> to point to the new version of both the data and its checksum, instead 
> of
> the old one.

Or an intent log, but I guess that introduces a lot of additional writes 
(and seeks) that would impact performance noticeably...

Gert

