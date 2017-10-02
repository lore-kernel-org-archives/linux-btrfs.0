Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.linuxsystems.it ([79.7.78.67]:43196 "EHLO
        mail.linuxsystems.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750891AbdJBL0X (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Oct 2017 07:26:23 -0400
To: Paul Jones <paul@pauljones.id.au>
Subject: RE: Is it really possible to dedupe read-only snapshots!?
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Mon, 02 Oct 2017 13:26:22 +0200
From: =?UTF-8?Q?Niccol=C3=B2_Belli?= <darkbasic@linuxsystems.it>
Cc: linux-btrfs@vger.kernel.org
In-Reply-To: <MEXPR01MB216878C061CDA1682E356D4A9E7D0@MEXPR01MB2168.ausprd01.prod.outlook.com>
References: <49ec6395-19b4-46e0-83cf-806ef6cdd396@linuxsystems.it>
 <e5bd0dc3-f7a5-7461-0630-6f755425009f@mendix.com>
 <569fb850091001ea7476100eae050c00@linuxsystems.it>
 <MEXPR01MB216878C061CDA1682E356D4A9E7D0@MEXPR01MB2168.ausprd01.prod.outlook.com>
Message-ID: <6fca958654a4c2ba57f83bbda83ee0a4@linuxsystems.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Il 2017-10-02 13:14 Paul Jones ha scritto:
> I use bees for deduplication and it will quite happily dedupe
> read-only snapshots.

AFAIK no, it isn't possible. Source: 
https://www.spinics.net/lists/linux-btrfs/msg60385.html
"It should be possible to deduplicate a read-only file to a read-write 
one, but that's probably not worth the effort in many real-world use 
cases."

> You could always change them to RW while dedupe
> is running then change back to RO.

AFAIK it will break send/receive, can someone confirm?

Niccolò
