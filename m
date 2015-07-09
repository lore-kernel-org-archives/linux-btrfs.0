Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f50.google.com ([209.85.216.50]:41778 "EHLO
	mail-vn0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbbGIAh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jul 2015 20:37:56 -0400
Received: by vnbf62 with SMTP id f62so17049520vnb.8
        for <linux-btrfs@vger.kernel.org>; Wed, 08 Jul 2015 17:37:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAFdkf7PPbH0mw1KW2TkkF5bm=cjN2iJEOzZwVAxh0f1xzjDWuA@mail.gmail.com>
References: <CAFdkf7Pqkjf=H11LaGQusDE_OT3zK1civwrHWeqmTS27uB4FPA@mail.gmail.com>
	<CAJCQCtT6csRoN+Bbfx=u8LHCZMnrsoBff+nbatXvCqVU-0iOGg@mail.gmail.com>
	<CAFdkf7PPbH0mw1KW2TkkF5bm=cjN2iJEOzZwVAxh0f1xzjDWuA@mail.gmail.com>
Date: Wed, 8 Jul 2015 18:37:56 -0600
Message-ID: <CAJCQCtSWiKdd3ronRkofuprKgD9Bof=MQQsqBUEpjLNkuRmRZg@mail.gmail.com>
Subject: Re: Error while balance after convert from ext4
From: Chris Murphy <lists@colorremedies.com>
To: =?UTF-8?B?0J3QuNC60L7Qu9Cw0Lkg0J7QstGH0LjQvdC90LjQutC+0LI=?=
	<nik.ovchin@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 8, 2015 at 1:38 PM, Николай Овчинников <nik.ovchin@gmail.com> wrote:
> What about btrfsck and btrfs-image errors?

btrfs check and btrfs-image both crash, which I consider as a separate
bug. And the crash doesn't produce useful info so I think it's a case
where I need to include either some gdb or valgrind info but I suck at
both and don't really know what to include in such a bug report.

The gist right now is that ext4 to btrfs conversion appears to be
broken, using defaults. I vaguely recall within the last, month (?), a
dev suggested using -n option to disable inlining of small files and
maybe that helped someone. I didn't test that.

-- 
Chris Murphy
