Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout06.t-online.de ([194.25.134.19]:39340 "EHLO
	mailout06.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab2FTBIL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 21:08:11 -0400
Date: 20 Jun 2012 02:39:00 +0200
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CBFTB8kPCXB@helmut.hullen.de>
In-Reply-To: <20120619234919.GA4102@shiny>
Subject: Re: Subvolumes and /proc/self/mountinfo
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Chris,

Du meintest am 19.06.12:

>> I'm trying to figure out an algorithm from taking an arbitrary
>> mounted btrfs directory and break it down into:
>>
>> <device(s), subvolume, subpath>
>>
>> where, keep in mind, <subpath> may not actually be part of the
>> mount.

> Do you want an API for this, or is it enough to wander through
> /dev/disk style symlinks?

> The big reason it isn't here yet is because Kay had this neat patch
> to blkid and udev to just put all the info you need into /dev/btrfs
> (or some other suitable location).  It would allow you to see which
> devices belong to which filesystems etc.

"btrfs" should work even without any "udev" installation.

Viele Gruesse!
Helmut
