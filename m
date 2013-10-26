Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f66.google.com ([74.125.83.66]:39976 "EHLO
	mail-ee0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3JZVA3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Oct 2013 17:00:29 -0400
Received: by mail-ee0-f66.google.com with SMTP id t10so497200eei.9
        for <linux-btrfs@vger.kernel.org>; Sat, 26 Oct 2013 14:00:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEezp7tJ3eouogd2zuDuLVnAhHk8VPi7ytFNQ1Rh51vfioVzHg@mail.gmail.com>
References: <CAEezp7tJ3eouogd2zuDuLVnAhHk8VPi7ytFNQ1Rh51vfioVzHg@mail.gmail.com>
Date: Sat, 26 Oct 2013 23:00:28 +0200
Message-ID: <CAEezp7s=44iMfmhxsOoeukex9BABU_5CvmWuU_Ha_vyZRAefcw@mail.gmail.com>
Subject: Re: No space left on device, problem
From: Igor M <igork20@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Some more info, exact error message is:

cp: writing ‘/usr/local/mysql/data/gbdata/parts_0015.MYI’: No space
left on device
cp: failed to extend ‘/usr/local/mysql/data/gbdata/parts_0015.MYI’: No
space left on device

Files are 2.7G - 7.7G big.

On Sat, Oct 26, 2013 at 9:46 PM, Igor M <igork20@gmail.com> wrote:
> Hello,
>
> I just upgraded kernel to 3.11.6 added new disk and created btrfs:
>
> # mkfs.btrfs /dev/sdb
> # mount -t btrfs -o compress=lzo,compress-force=lzo /dev/sdb
> /usr/local/mysql/data
>
> I started copying files from old disk and then I got 'No space left on
> device', but there is a lot of space.
>
> # df -h
> Filesystem                Size  Used Avail Use% Mounted on
> /dev/sdb                  2.8T  110G  2.7T   4% /usr/local/mysql/data
>
> # btrfs fi show
> Label: none  uuid: c0bfcb22-8b7c-4936-afcd-7acdf58f1d6c
>         Total devices 1 FS bytes used 108.68GB
>         devid    1 size 2.73TB used 113.04GB path /dev/sdb
>
> # btrfs fi df /usr/local/mysql/data
> Data: total=111.01GB, used=108.25GB
> System, DUP: total=8.00MB, used=20.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=441.91MB
> Metadata: total=8.00MB, used=0.00
>
> I tried balance from FAQ:
>
> # btrfs fi balance start -dusage=5 /usr/local/mysql/data
> Done, had to relocate 4 out of 117 chunks
>
>
> But it doesn't help. When I try to copy file there is still 'No space
> left on device'.
>
> What to do ?
>
>
> Regards,
>
> Igor
