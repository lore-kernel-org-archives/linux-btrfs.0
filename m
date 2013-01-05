Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout05.t-online.de ([194.25.134.82]:43061 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab3AENTr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 5 Jan 2013 08:19:47 -0500
Date: 05 Jan 2013 14:15:00 +0100
From: Hullen@t-online.de (Helmut Hullen)
To: linux-btrfs@vger.kernel.org
Message-ID: <COGohh5PCXB@helmut.hullen.de>
In-Reply-To: <20130103160853.GA19051@carfax.org.uk>
Subject: Re: Option LABEL
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Reply-To: helmut@hullen.de
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 03.01.13:

>> My usual way:
>>
>>         mkfs.btrfs -d raid0 -m raid1 /dev/sdb /dev/sdc /dev/sdd ...
>>
>> One call for some devices.
>> Wenn I add the option "-L mylabel" then each device gets the same
>> label, and therefore some other programs can't find the (one) device
>> with the defined label.

[...]

>> Especially
>>
>>      blkid
>>      findfs LABEL=mylabel
>>
>> don't work.

>    How do you mean, "don't work"?

Seems to be a problem which is invoked by "btrfs-show".

Working with an USB stick (3 btrfs partitions, labelled), working as  
"root", kernel 3.6.11

cold start
inserting the stick

        btrfs device scan       ok
        btrfs fi show           ok
        blkid                   ok

cold start
inserting the stick

        btrfs device scan       ok
        blkid                   ok
        btrfs-show              ok (?)
        blkid                   hangs

Maybe the simpliest way is to delete "btrfs-show".

Viele Gruesse!
Helmut
