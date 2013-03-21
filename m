Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout05.t-online.de ([194.25.134.82]:55612 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab3CUPzv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 11:55:51 -0400
Date: 21 Mar 2013 16:33:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <CTGgJoCuCXB@helmut.hullen.de>
In-Reply-To: <CAKuK5J3Fd+ya3SOwQPZohJArE+cPNZKchzH3UkvpvoAnK-6Hng@mail.gmail.com>
Subject: Re: btrfs-show vs. btrfs different output
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Jon,

Du meintest am 21.03.13:

>>> 2. the current git btrfs-show and btrfs fi show both output
>>> *different* devices for device with UUID
>>> b5dc52bd-21bf-4173-8049-d54d88c82240, and they're both wrong.

>> does blkid output find that uuid anywhere?

>> Since you're working in git, can you maybe do a little bisecting
>> to find out when it changed?  Should be a fairly quick test?

> blkid does /not/ report that uuid anywhere.

"blkid" seems to be a bit clueless.
Try "file -s" instead.

Viele Gruesse!
Helmut
