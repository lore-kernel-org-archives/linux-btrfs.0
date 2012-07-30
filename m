Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout07.t-online.de ([194.25.134.83]:33031 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2G3KZ1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 06:25:27 -0400
Date: 30 Jul 2012 11:59:00 +0200
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CDqX2gsuCXB@helmut.hullen.de>
In-Reply-To: <50165584.70707@arndnet.de>
Subject: Re: severe hardlink bug
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Arnd,

Du meintest am 30.07.12:

>> btrfs only fails when you have hundreds of hardlinks to the same
>> file in the *same* directory ... certainly not a standard use case.

> Actually, "hundreds of hardlinks" is certainly over optimistic.
> In my testing 15 links in the same directory were enough to get
> the "Too many links" error. It depends on the length of the file
> name of the hardlinks.

And then I may get problems with my favourite backup program  
"rsnapshot"; it uses hard links, and my backups often have more than 20  
hard links to 1 file. Sometimes about 80 characters long.

Viele Gruesse!
Helmut
