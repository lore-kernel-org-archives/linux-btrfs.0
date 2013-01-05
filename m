Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout07.t-online.de ([194.25.134.83]:35620 "EHLO
	mailout07.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab3AEQHQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jan 2013 11:07:16 -0500
Date: 05 Jan 2013 16:52:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <COGpJewPCXB@helmut.hullen.de>
In-Reply-To: <CAMQ-g0c32nrFGDm5qP3u8iGC9FrdTyZ0Apm2N+F0BJyS+RYpgg@mail.gmail.com>
Subject: Re: cleaning old entries
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Jan,

Du meintest am 05.01.13:

>> Has "mkfs.btrfs" to delete the "/dev/sdb" data when it overwrites
>> the configuration with data for partitions? Or has the user to run
>> something like "dd if=/dev/zero ..."?

> Take a look at:
> https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_to_clean_up_o
> ld_superblock_.3F

Thank you - "wipefs" may help.

Viele Gruesse!
Helmut
