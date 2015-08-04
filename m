Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f50.google.com ([209.85.213.50]:36629 "EHLO
	mail-vk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbbHDOiL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 4 Aug 2015 10:38:11 -0400
Received: by vkci6 with SMTP id i6so4349317vkc.3
        for <linux-btrfs@vger.kernel.org>; Tue, 04 Aug 2015 07:38:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55C02AF9.3070600@cn.fujitsu.com>
References: <CAJ3TwYQXqUZiKhYc5rciTmvGX1RLkHnkQb5SSYAJ7AD+kbudag@mail.gmail.com>
	<55BADEC4.3020409@cn.fujitsu.com>
	<CAJ3TwYRN+1tJY+paz=qZT0_XP=r9CcTKbBgX_kZRFOWj8vSK=w@mail.gmail.com>
	<55BAFEF9.1070107@cn.fujitsu.com>
	<CAJ3TwYR5g-JhjmGnZUXqLXc7qV1_=AN5_6sj54JQODbtgG9Aag@mail.gmail.com>
	<55BB0A39.1050208@cn.fujitsu.com>
	<CAJ3TwYS+yL8Tk8d3uigpXrfD+dcn2G4tWwbF7jcB=BCDZqs6+g@mail.gmail.com>
	<CAJ3TwYQc3d5R6r+tjY9mxUzptWA_MktUbZeaQebmNRBuqB7zYA@mail.gmail.com>
	<55C017E7.40704@cn.fujitsu.com>
	<CAJ3TwYTd_8-uwn-osNsf6UAuxGvoJCeWmxWYNHmzXoF_+yrABA@mail.gmail.com>
	<55C02AF9.3070600@cn.fujitsu.com>
Date: Tue, 4 Aug 2015 08:38:10 -0600
Message-ID: <CAJCQCtTyV4K7OCZfi0BnWt7bnyK-dZOb=JjPtfmzOeyvneZVwQ@mail.gmail.com>
Subject: Re: mount btrfs takes 30 minutes, btrfs check runs out of memory
From: Chris Murphy <lists@colorremedies.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: btrfs <linux-btrfs@vger.kernel.org>, Hugo Mills <hugo@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 3, 2015 at 9:01 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:

> Oh, converted...
> That's too bad. :(
>
> [[What's wrong with convert]]
> Although btrfs is flex enough in theory to fit itself into the free space of
> ext* and works fine,
> But in practice, ext* is too fragmental in the standard of btrfs, not to
> mention it also enables mixed-blockgroup.

There is an -f flag for mkfs to help users avoid accidents. Is there a
case to be made for btrfs-convert having either a -f flag, or an
interactive

"Convert has limitations that could increase risk to data, please see
the wiki. Continue? y/n"
OR
"Convert has limitations, is not recommended for production usage,
please see the wiki. Continue? y/n"

It just seems users are jumping into convert without reading the wiki
warning. Is it a good idea to reduce problems for less experienced
users by actively discouraging btrfs-convert for production use?



-- 
Chris Murphy
