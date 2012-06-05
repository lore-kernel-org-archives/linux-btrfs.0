Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout08.t-online.de ([194.25.134.20]:59832 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab2FERfh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 13:35:37 -0400
Date: 05 Jun 2012 19:23:00 +0200
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CAIjB+XuCXB@helmut.hullen.de>
In-Reply-To: <20120605170420.GJ15986@carfax.org.uk>
Subject: Re: delete disk proceedure
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 05.06.12:

[...]

>> And you can't use the console from where you have started the
>> "balance" command. Therefore I wrap this command:
>>
>>       echo 'btrfs filesystem balance /btrfs' | at now

>    ... or just put it into the background with "btrfs bal start
> /mountpoint &". You know, like everyone else does. :)

I know that possibility too. My proposal puts every message ("normal"  
messages and error messages) into a mail to "root" (when root has  
started this command).

Viele Gruesse!
Helmut
