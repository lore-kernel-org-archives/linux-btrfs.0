Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53102 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935526Ab2JaN1o (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Oct 2012 09:27:44 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so2004822iea.19
        for <linux-btrfs@vger.kernel.org>; Wed, 31 Oct 2012 06:27:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20121031115639.GB26070@yeono.kjorling.se>
References: <CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com>
	<50904949.8010603@gmail.com>
	<20121030221412.GB11422@carfax.org.uk>
	<20121030221947.GC11422@carfax.org.uk>
	<50906702.1010608@gmail.com>
	<CAE5mzvgMskhBgH506BageXREifs63Zn_HKDaWBMuesS8Np66SQ@mail.gmail.com>
	<CAFDW0j+1wx2_ZewQ69W7fyLuMyYxq29g62FGH5uX9kAFv-H3eQ@mail.gmail.com>
	<CAE5mzvgRqTC+zismMUt0AOYWP52EN9taowARqU=he1cmVMSTEQ@mail.gmail.com>
	<CAFDW0jLGFwrg-9GDoBUxHa6M0ZgjB4W4GJg3b88+6L-dGLJMUw@mail.gmail.com>
	<CAE5mzvjc2EfZ-+P55PukWmM7EduOdBephnuBGAe2JPKuOiQ0vg@mail.gmail.com>
	<20121031115639.GB26070@yeono.kjorling.se>
Date: Wed, 31 Oct 2012 14:27:43 +0100
Message-ID: <CAFDW0jJSP1w0pDf66qcvkaaf3wAt_G6B0k102v_zJvt9-9WNpA@mail.gmail.com>
Subject: Re: Why btrfs inline small file by default?
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: =?UTF-8?Q?Michael_Kj=C3=B6rling?= <michael@kjorling.se>
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> 9.08GB + 992.48MB*2 == 11.02GB
>> 10.85GB + 518MB*2 == 11.86GB
>> That's nearly a GB smaller.
> That, too; I missed the "DUP". Not quite as pronounced as in my
> calculations, then, but still a significant enough difference.

great. now were down to 7-8%

just FYI:

ive retested with max_inline=0 but with leafsize=64K this time:
# mkfs.btrfs -l 64K -L root /dev/sda2
...
real    4m45.878s
user    1m44.730s
sys     1m7.226s

thats 2% slower for this one test (no big deal really)

# btrfs filesystem show
Label: 'root'  uuid: dd2951da-2529-4320-a952-e692ea5bdbc3
        Total devices 1 FS bytes used 11.37GB
        devid    1 size 232.63GB used 13.04GB path /dev/sda2

Btrfs v0.20-rc1

# btrfs filesystem df /mnt/point/
Data: total=11.01GB, used=10.89GB
System, DUP: total=8.00MB, used=64.00KB
System: total=4.00MB, used=0.00
Metadata, DUP: total=1.00GB, used=487.94MB
Metadata: total=8.00MB, used=0.00

(1024*10.89 + 2*487.94) / 1024 = 11.84GiB

still around 7-8%

now lets see what everyday use with
max_inline=0 and leafsize=64K
feels like :)

Ahmet
