Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout09.t-online.de ([194.25.134.84]:37673 "EHLO
	mailout09.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755264Ab3AEMpZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jan 2013 07:45:25 -0500
Date: 05 Jan 2013 13:44:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <COGoZAXPCXB@helmut.hullen.de>
In-Reply-To: <201301051236.37875.Martin@lichtvoll.de>
Subject: Re: Option LABEL
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Martin,

Du meintest am 05.01.13:

>> No - I don't rely on such an assumption.
>> In the special case I'm just working with I want to use the whole
>> disk only for btrfs.
>>
>> In other cases I work with partitions, and there is just the same
>> problem: at least "blkid" and "findfs" don't work when more than 1
>> device has the same label (p.e. /dev/sda3 and /dev/sdc5).

It seems to be a problem which is related to "blkid".

> Helmut, it has been shown here in the thread, that they *do* work in
> newer versions.

> If they don?t work for you please compare your version with the ones
> that do work and file a bug report for your Linux distribution.

   blkid from util-linux 2.21.2 (libblkid 2.21.0, 25-May-2012
   findfs from the same "util-linux" packet
   kernel 3.6.11

Is that new enough?

-------------------------------------------

Reproducable:
USB stick with 3 btrfs partitions

cold start without stick, logged in as "root"
        blkid           works

Stick inserted:
        blkid           works
        fdisk -l        works

   btrfs device scan    works
        blkid           works

   btrfs-show           works
        blkid           hangs

        blkid /dev/sdb1 works

I don't know who may be responsible for this problem - btrfs or blkid or  
both.



Viele Gruesse!
Helmut
