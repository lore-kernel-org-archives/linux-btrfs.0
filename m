Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:15368 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753566AbbLEKlw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Dec 2015 05:41:52 -0500
From: Wolfgang Rohdewald <wolfgang.kde@rohdewald.de>
To: Holger =?ISO-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs balance: Kernel BUG
Date: Sat, 05 Dec 2015 11:41:55 +0100
Message-ID: <2955386.PhuU2Cp9IO@i5>
In-Reply-To: <5662B9B6.4050705@googlemail.com>
References: <1795110.jZOk3ROKzF@i5> <3429895.kYSi8bYfa6@i5> <5662B9B6.4050705@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 5. Dezember 2015, 11:17:26 schrieb Holger Hoffstätte:
> On 12/05/15 11:04, Wolfgang Rohdewald wrote:
> > Am Samstag, 5. Dezember 2015, 10:58:44 schrieb Holger Hoffstätte:
> >> Please see: http://www.spinics.net/lists/linux-btrfs/msg49766.html
> >>
> >> You should be able to apply those patches manually (assuming you can/want to rebuild).
> > 
> > are my data safe if I just wait for a fixed official kernel and do not
> > balance until then?
> 
> This is not directly caused by balance, so it's possible to triger it also
> during normal operation. Another option would be to revert to 4.1.13 for the
> time being.

thanks, I am now building 4.3 with patch applied

-- 
Wolfgang
