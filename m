Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:35959 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab2FQIFI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 17 Jun 2012 04:05:08 -0400
Received: by obbtb18 with SMTP id tb18so6670912obb.19
        for <linux-btrfs@vger.kernel.org>; Sun, 17 Jun 2012 01:05:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339910379.1538.4.camel@ierdnac-hp>
References: <CAJs9aZ9gsM-hcH-YJpgN6f_YEHrcdJfm808TuCLRKWd1qEGXwg@mail.gmail.com>
 <20120616145704.039809d2@sf.home> <CAJs9aZ-9EK2HUuvBDuiPSG2O5J16seO6Hp3=wJLYAJBi9KDL+Q@mail.gmail.com>
 <CAJs9aZ_C5CzyuudeUg585M4SifunchrmVDg5rXQoo7kDAsOMpw@mail.gmail.com> <1339910379.1538.4.camel@ierdnac-hp>
From: rupert THURNER <rupert.thurner@gmail.com>
Date: Sun, 17 Jun 2012 10:04:47 +0200
Message-ID: <CAJs9aZ-bTEPyJBiLxQozu71-atP958wp95HhyfFgTb+2y2kLLA@mail.gmail.com>
Subject: Re: cannot remove files: "rm" gives "no space left on device",
 3.2.0-24, ubuntu
To: ierdnah@gmail.com
Cc: Sergei Trofimovich <slyich@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 17, 2012 at 7:19 AM, Andrei Popa <ierdnah@gmail.com> wrote:
> On Sun, 2012-06-17 at 06:14 +0200, rupert THURNER wrote:
>> >> Will result in anything reported in 'dmesg' output?
>> > [ 6431.514454] device label 388gb-data devid 1 transid 1086 /dev/sda6
>> > [ 6431.514969] btrfs: disabling disk space caching
>> > [ 6431.514977] btrfs: force clearing of disk cache
>> tried the same with kernel versions from
>> http://kernel.ubuntu.com/~kernel-ppa/mainline/:
>> * 3.2.20
>> * 3.4.0
>> with version 3.4.0, i could delete one tiny file, but only one. peter
>> mentioned before to run the rm as root. yes, i did that, with all
>> kernel versions, the error was the same all the time.
>
> Have you tried to delete the files with "echo > file" ? This will empty
> the file without requiring a new metadata allocation.

thanks for the hint! i did with the original kernel, but now i tried
it as root and with the 3.4.0 kernel as well. "no space left on
device". is there a  special kernel version or a special btrfs tool
which allows to remove a file without writing more data?

rupert.
