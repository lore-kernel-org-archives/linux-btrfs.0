Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout05.t-online.de ([194.25.134.82]:41044 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788Ab2FFPzG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jun 2012 11:55:06 -0400
Date: 06 Jun 2012 17:52:00 +0200
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CAMmdFRuCXB@helmut.hullen.de>
In-Reply-To: <20120606154032.GO15986@carfax.org.uk>
Subject: Re: New btrfs-progs integration branch
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 06.06.12:

>>> However, the third line with the problem looks like something out
>>> of date. Possibly a mis-merge?
>>
>> Where should I search?

>    Well, the first thing would be to try a completely new clone of
> the repo, then git co integration-20120605, and run make again.

I had a brand new git clone.

Produced with

[...]
git clone http://git.darksatanic.net/repo/btrfs-progs-unstable.git
cd btrfs-progs-unstable
git checkout integration-20120605

(and "btrfs-progs-unstable" had been empty before "checkout")

> If
> that's OK, then take a look with gitk in the broken repo and see what
> kind of history you've got in there -- it should be a single unbroken
> sequence from "master" (1957076ab4fefa47b6efed3da541bc974c83eed7) to
> "integration-20120605" (d4c539067d1cb2476c7fb6003625de26e84059af).

I don't know much about working with git ... but I suppose I'm not  
working with such things as a (broken) repo.

It's the same way I had successfully compiled your version from 20111012  
and from 20111030.

Is there any change compiling the new version?

Viele Gruesse!
Helmut
