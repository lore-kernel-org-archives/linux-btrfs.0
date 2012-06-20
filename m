Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46555 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab2FTBQX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Jun 2012 21:16:23 -0400
Received: by yenl2 with SMTP id l2so4812664yen.19
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Jun 2012 18:16:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CBFTB8kPCXB@helmut.hullen.de>
References: <20120619234919.GA4102@shiny>
	<CBFTB8kPCXB@helmut.hullen.de>
Date: Tue, 19 Jun 2012 19:16:23 -0600
Message-ID: <CAE5mzvitiXX9N=qjM=xRgqhHQ9kY6WHXa4jWKGs6xRNOtd7uEA@mail.gmail.com>
Subject: Re: Subvolumes and /proc/self/mountinfo
From: cwillu <cwillu@cwillu.com>
To: helmut@hullen.de
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> The big reason it isn't here yet is because Kay had this neat patch
>> to blkid and udev to just put all the info you need into /dev/btrfs
>> (or some other suitable location).  It would allow you to see which
>> devices belong to which filesystems etc.
>
> "btrfs" should work even without any "udev" installation.

It does; you can always mount with an explicit -o
device=/dev/foo,device=/dev/bar if you're inclined to punish
yourself^w^w^w^w^w your requirements dictate that you don't rely on
udev.
