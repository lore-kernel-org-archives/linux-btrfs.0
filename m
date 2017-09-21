Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sender-of-o52.zoho.com ([135.84.80.217]:21422 "EHLO
        sender-of-o52.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751581AbdIUNks (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 21 Sep 2017 09:40:48 -0400
Date: Thu, 21 Sep 2017 10:40:47 -0300
From: grondinm <marcfgrondin@gcfam.net>
To: "linux-btrfs" <linux-btrfs@vger.kernel.org>
Message-ID: <15ea4ab5c03.f7184be1227921.7646342158765250928@gcfam.net>
In-Reply-To: 
Subject: Re: Help Recovering BTRFS array
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Duncan,

I'm not sure if this will attache to my original message...

Thank you for your reply. For some reason i'm not getting list messages even tho i know i am subscribed.

I know all to well about the golden rule of data. It has bitten me  a few times. The data on this array is mostly data that i don't really care about. I was able to copy off what i wanted. The main reason i sent it to the list was just to see if i could somehow return the FS to a working state without having to recreate. I'm just surprised that all 3 copies of the super block got corrupted. Probably my lack of understanding but i always assumed that if one copy got corrupted it would be replaced by a good copy therefore leaving all copies in a good state. Is that not the case. If it is then what back luck that all 3 got messed up at same time. 

Some information i forgot to include in my original message

uname -a
Linux thebeach 4.12.13-gentoo-GMAN #1 SMP Sat Sep 16 15:28:26 ADT 2017 x86_64 Intel(R) Core(TM) i5-2320 CPU @ 3.00GHz GenuineIntel GNU/Linux

btrfs --version
btrfs-progs v4.10.2

Anyways thank you again for your reply. I will leave the FS intact for a few days in case anymore details could help the development of BTRFS and maybe avoid this happening or having a recovery option.

Marc


