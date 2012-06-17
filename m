Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:40617 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739Ab2FQFUs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jun 2012 01:20:48 -0400
Received: by wibhj8 with SMTP id hj8so900373wib.1
        for <linux-btrfs@vger.kernel.org>; Sat, 16 Jun 2012 22:20:47 -0700 (PDT)
Message-ID: <1339910379.1538.4.camel@ierdnac-hp>
Subject: Re: cannot remove files: "rm" gives "no space left on device",
 3.2.0-24, ubuntu
From: Andrei Popa <ierdnah@gmail.com>
Reply-To: ierdnah@gmail.com
To: rupert THURNER <rupert.thurner@gmail.com>
Cc: Sergei Trofimovich <slyich@gmail.com>, linux-btrfs@vger.kernel.org
Date: Sun, 17 Jun 2012 08:19:39 +0300
In-Reply-To: <CAJs9aZ_C5CzyuudeUg585M4SifunchrmVDg5rXQoo7kDAsOMpw@mail.gmail.com>
References: <CAJs9aZ9gsM-hcH-YJpgN6f_YEHrcdJfm808TuCLRKWd1qEGXwg@mail.gmail.com>
	 <20120616145704.039809d2@sf.home>
	 <CAJs9aZ-9EK2HUuvBDuiPSG2O5J16seO6Hp3=wJLYAJBi9KDL+Q@mail.gmail.com>
	 <CAJs9aZ_C5CzyuudeUg585M4SifunchrmVDg5rXQoo7kDAsOMpw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2012-06-17 at 06:14 +0200, rupert THURNER wrote:
> >> Will result in anything reported in 'dmesg' output?
> > [ 6431.514454] device label 388gb-data devid 1 transid 1086 /dev/sda6
> > [ 6431.514969] btrfs: disabling disk space caching
> > [ 6431.514977] btrfs: force clearing of disk cache
> tried the same with kernel versions from
> http://kernel.ubuntu.com/~kernel-ppa/mainline/:
> * 3.2.20
> * 3.4.0
> with version 3.4.0, i could delete one tiny file, but only one. peter
> mentioned before to run the rm as root. yes, i did that, with all
> kernel versions, the error was the same all the time.

Have you tried to delete the files with "echo > file" ? This will empty
the file without requiring a new metadata allocation.

Andrei

