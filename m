Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:43424
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbbLEKR1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Dec 2015 05:17:27 -0500
Subject: Re: btrfs balance: Kernel BUG
To: Wolfgang Rohdewald <wolfgang.kde@rohdewald.de>
References: <1795110.jZOk3ROKzF@i5> <5662B554.3010604@googlemail.com>
 <3429895.kYSi8bYfa6@i5>
Cc: linux-btrfs@vger.kernel.org
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <5662B9B6.4050705@googlemail.com>
Date: Sat, 5 Dec 2015 11:17:26 +0100
MIME-Version: 1.0
In-Reply-To: <3429895.kYSi8bYfa6@i5>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/05/15 11:04, Wolfgang Rohdewald wrote:
> Am Samstag, 5. Dezember 2015, 10:58:44 schrieb Holger Hoffstätte:
>> Please see: http://www.spinics.net/lists/linux-btrfs/msg49766.html
>>
>> You should be able to apply those patches manually (assuming you can/want to rebuild).
> 
> are my data safe if I just wait for a fixed official kernel and do not
> balance until then?

This is not directly caused by balance, so it's possible to triger it also
during normal operation. Another option would be to revert to 4.1.13 for the
time being.

-h

