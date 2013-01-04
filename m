Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout03.t-online.de ([194.25.134.81]:49202 "EHLO
	mailout03.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab3ADVGV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 4 Jan 2013 16:06:21 -0500
Date: 04 Jan 2013 21:59:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <COCn3oPuCXB@helmut.hullen.de>
In-Reply-To: <20130103212342.GE19051@carfax.org.uk>
Subject: Re: Option LABEL
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 03.01.13:

[...]

>>> And then for blkid:
>>
>>> # blkid
>>> /dev/sdb: LABEL="test2" UUID="3d5390d0-a41b-4f70-a4e5-b47295d3c717"
>>> UUID_SUB="a5bbaa83-6d6f-45dc-9804-9442350c3bc9" TYPE="btrfs"
>>> /dev/sdc: LABEL="test2" UUID="3d5390d0-a41b-4f70-a4e5-b47295d3c717"
>>> UUID_SUB="01e0bc77-cfdf-4bd7-bfd3-05e14affa66a" TYPE="btrfs"
>>
>> Strange - in another way.
>>
>> Here "blkid" (without any device) hangs. See the attachment ("strace
>> blkid").

Additional:

Working as "root":

        blkid

hangs (at least sometimes).

Working as underprivileged user:

        /sbin/blkid

shows many informations (and doesn't hang). But it doesn't show the  
btrfs devices/partitions.

        /sbin/blkid /dev/sdb

shows the btrfs label.

Maybe it's mostly or only a blkid problem - I'll subscribe the "util- 
linux" mailinglist.

--------------------------------

Viele Gruesse!
Helmut
