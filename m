Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zimbra.karlsbakk.net ([82.211.30.250]:46694 "EHLO
        zimbra.karlsbakk.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752259AbdKTT22 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Nov 2017 14:28:28 -0500
Date: Mon, 20 Nov 2017 20:28:25 +0100 (CET)
From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Steffen Sindzinski <stesind@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <1715330308.212241.1511206105055.JavaMail.zimbra@karlsbakk.net>
In-Reply-To: <CAJCQCtSLG5hXikEiBD4OF5G+EfKgyALaynqivBvCaWLpEYQjEw@mail.gmail.com>
References: <a61eeda7-af07-e140-ccd9-d288931f07fb@gmail.com> <CAJCQCtSLG5hXikEiBD4OF5G+EfKgyALaynqivBvCaWLpEYQjEw@mail.gmail.com>
Subject: Re: uncorrectable errors in Raid 10
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> On Sun, Nov 19, 2017 at 12:31 PM, Steffen Sindzinski <stesind@gmail.com> wrote:
> 
>> [57830.611730] BTRFS warning (device sdc2): checksum/header error at logical
>> 17478699876352 on dev /dev/sdd2, sector 338986176: metadata leaf (level 0)
>> in tree 318
>> [57830.611732] BTRFS warning (device sdc2): checksum/header error at logical
>> 17478699876352 on dev /dev/sdd2, sector 338986176: metadata leaf (level 0)
>> in tree 318
> 
> The same leaf is corrupt in the same physical sector on two devices.
> I'm guessing the checksum was computed incorrectly and written twice,
> affecting both copies. I doubt it's a device problem. It might be
> useful to look through the archives specifically for checksum header
> error, it's kinda interesting Btrfs knows the problem is specifically
> there.

Sounds reasonable. Perhaps a memory check on the machine would be a good idea_

roy
