Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:33482 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaBAPSD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 1 Feb 2014 10:18:03 -0500
Received: by mail-bk0-f45.google.com with SMTP id v16so2470055bkz.18
        for <linux-btrfs@vger.kernel.org>; Sat, 01 Feb 2014 07:18:01 -0800 (PST)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CAFDW0j+7roYdCaCsFoQWUdifhyLCgDL5JAbmEkDeF_Fx2+YdrA@mail.gmail.com>
References: <1389475651-19179-1-git-send-email-fdmanana@gmail.com>
	<1389493366-15264-1-git-send-email-fdmanana@gmail.com>
	<20140130031135.GA8796@birch.djwong.org>
	<CAL3q7H7fT9Mz6m=a2iqHgSyGgYO28aRt_BFc95gQYOh4gaRA2A@mail.gmail.com>
	<20140130215634.GB8796@birch.djwong.org>
	<CAFDW0jJ__9EbidepKD1uF239H3ZDMvZszw_f_Nsem9iuX4Rv-w@mail.gmail.com>
	<CAFDW0j+7roYdCaCsFoQWUdifhyLCgDL5JAbmEkDeF_Fx2+YdrA@mail.gmail.com>
Date: Sat, 1 Feb 2014 15:18:01 +0000
Message-ID: <CAL3q7H4cUj3p+mNBciMjoT0QSXfCWmc61QLWKgLNZSKRx0+JbQ@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: fix btrfs boot when compiled as built-in
From: Filipe David Manana <fdmanana@gmail.com>
To: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Feb 1, 2014 at 10:29 AM, Ahmet Inan
<ainan@mathematik.uni-freiburg.de> wrote:
> okay, putting late_initcall instead of module_init fixes it for me,
> but this is something you guys should decide how to handle:
>
> //module_init(init_btrfs_fs)
> late_initcall(init_btrfs_fs);

Thanks for reporting and testing Ahmet.

I tried late_initcall too, both when built as a module and as
built-in. Seems to work too on my hardware.
Out of curiosity, what error were you getting exactly? Can you paste
the stack trace from dmesg?


>
> Ahmet



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
