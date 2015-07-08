Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33906 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384AbbGHTiV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 15:38:21 -0400
Received: by pdbep18 with SMTP id ep18so150698742pdb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 12:38:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT6csRoN+Bbfx=u8LHCZMnrsoBff+nbatXvCqVU-0iOGg@mail.gmail.com>
References: <CAFdkf7Pqkjf=H11LaGQusDE_OT3zK1civwrHWeqmTS27uB4FPA@mail.gmail.com>
	<CAJCQCtT6csRoN+Bbfx=u8LHCZMnrsoBff+nbatXvCqVU-0iOGg@mail.gmail.com>
Date: Wed, 8 Jul 2015 22:38:20 +0300
Message-ID: <CAFdkf7PPbH0mw1KW2TkkF5bm=cjN2iJEOzZwVAxh0f1xzjDWuA@mail.gmail.com>
Subject: Re: Error while balance after convert from ext4
From: =?UTF-8?B?0J3QuNC60L7Qu9Cw0Lkg0J7QstGH0LjQvdC90LjQutC+0LI=?=
	<nik.ovchin@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

What about btrfsck and btrfs-image errors?

2015-07-08 16:56 GMT+03:00 Chris Murphy <lists@colorremedies.com>:
> I've reproduced this bug with a brand new ext4 system, converted with
> btrfs-progs 4.1 and a 4.1 kernel. The conversion is OK. And btrfs
> check is ok after conversion, after removing the ext2_saved snapshot,
> and after defrag. The implosion happens on balance and the fs goes
> read only.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=101191
>
> I will double post this as a new thread, since I've found a different
> bug with the identical procedure and 4.2rc1.
>
> Chris Murphy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
