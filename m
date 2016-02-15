Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f196.google.com ([209.85.214.196]:36157 "EHLO
	mail-ob0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925AbcBOLIj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Feb 2016 06:08:39 -0500
Received: by mail-ob0-f196.google.com with SMTP id kg5so29694obb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 15 Feb 2016 03:08:39 -0800 (PST)
MIME-Version: 1.0
Reply-To: radek.sprta@gmail.com
In-Reply-To: <56B89285.7070303@gmx.com>
References: <CAM7-wL0OzZU9UvFHG0GauXz+ZSHg58CaPQR33CkxNRyPg6+SSg@mail.gmail.com>
 <CAM7-wL0kU5TkZaOac1PG5Drk1+JZxYE35-r8y0YiZ2ngmEu9zg@mail.gmail.com>
 <20160122152530.GX422@carfax.org.uk> <56B89285.7070303@gmx.com>
From: Radek Sprta <radek.sprta@gmail.com>
Date: Mon, 15 Feb 2016 11:42:25 +0100
Message-ID: <CAM7-wL2xzU4WmCW_p2MT=gy7Nbhr+OJF-SjE4Suys7xHDu8uVQ@mail.gmail.com>
Subject: Re: Fwd: Unmountable fs after power outage
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-02-08 14:05 GMT+01:00 Qu Wenruo <quwenruo.btrfs@gmx.com>:
> Quite strange.
> IIRC, btrfsck should at least report transid error.
> As written in disk-io.c, verify_parent_transid() function.
>
> Since btrfsck reports no error, I think btrfs-image could dump the metadata
> without problem.
>
> So, would you please dump a btrfs-image dump, by the following command?
> # btrfs-image -c9 /dev/sda8
>
> Such dump will only contain your metadata(dir/file hierarchy including
> dir/file names), no data will be dump.
>
> And if you think the filename can leak important data, you can use '-ss' or
> '-s' to sanitize them.
>
> Thanks,
> Qu

Here's the link fot the dump with -c9 -s options:
http://uloz.to/xkhERuoJ/dump-txt

R.
