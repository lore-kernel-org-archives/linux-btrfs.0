Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f45.google.com ([209.85.216.45]:43482 "EHLO
	mail-vn0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758209AbbGHN4s (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 09:56:48 -0400
Received: by vnbf1 with SMTP id f1so19763205vnb.10
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 06:56:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFdkf7Pqkjf=H11LaGQusDE_OT3zK1civwrHWeqmTS27uB4FPA@mail.gmail.com>
References: <CAFdkf7Pqkjf=H11LaGQusDE_OT3zK1civwrHWeqmTS27uB4FPA@mail.gmail.com>
Date: Wed, 8 Jul 2015 07:56:47 -0600
Message-ID: <CAJCQCtT6csRoN+Bbfx=u8LHCZMnrsoBff+nbatXvCqVU-0iOGg@mail.gmail.com>
Subject: Re: Error while balance after convert from ext4
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I've reproduced this bug with a brand new ext4 system, converted with
btrfs-progs 4.1 and a 4.1 kernel. The conversion is OK. And btrfs
check is ok after conversion, after removing the ext2_saved snapshot,
and after defrag. The implosion happens on balance and the fs goes
read only.

https://bugzilla.kernel.org/show_bug.cgi?id=101191

I will double post this as a new thread, since I've found a different
bug with the identical procedure and 4.2rc1.

Chris Murphy
