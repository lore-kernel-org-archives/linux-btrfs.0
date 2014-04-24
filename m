Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:49897 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757760AbaDXRdX (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 13:33:23 -0400
Date: Thu, 24 Apr 2014 10:33:17 -0700
From: Marc MERLIN <marc@merlins.org>
To: =?utf-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
Cc: linux-btrfs@vger.kernel.org
Message-ID: <20140424173317.GI7884@merlins.org>
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info>
 <20140423185413.GF26949@merlins.org>
 <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info>
 <20140423191546.GG26949@merlins.org>
 <000501cf5fe1$55198590$ff4c90b0$@petrovi.no-ip.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <000501cf5fe1$55198590$ff4c90b0$@petrovi.no-ip.info>
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
 newer?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 24, 2014 at 08:19:21PM +0300, Пламен Петров wrote:
> I just realized that the l gave no way for identifying the particular bugzilla entry. Here it is:
> https://bugzilla.kernel.org/show_bug.cgi?id=74261

Thanks.

But to save us a lot more speculation, can you please try booting a
linux system (either initrd, or another one with a non btrfs root), and
then trying to mount that filesystem from the command line?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
