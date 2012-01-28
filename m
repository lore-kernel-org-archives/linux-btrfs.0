From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Setting options permanently?
Date: Sat, 28 Jan 2012 19:07:02 +0700
Message-ID: <CAG1y0sfnwYr-brzPJo2VaxWbY8jyXA04=Am205wvjk-Voe9MBg@mail.gmail.com>
References: <4F22BCCC.5090800@danisch.de>
	<CAAE6i0gSG4xuyJFQrmfFNh3ojF4GBbsgk7LsN+1XD=9Mp5rSUQ@mail.gmail.com>
	<4F234616.6020407@danisch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chester <somethingsome2000@gmail.com>, linux-btrfs@vger.kernel.org
To: Hadmut Danisch <hadmut@danisch.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F234616.6020407@danisch.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jan 28, 2012 at 7:49 AM, Hadmut Danisch <hadmut@danisch.de> wrote:
> Am 28.01.2012 00:20, schrieb Chester:
>> It should be okay to mount with compress or without compress. Even if
>> you mount a volume with compressed data without '-o compress' you will
>> still be able to correctly read the data (but newly written data will
>> not be compressed)
>
> But having both compressed and uncompressed files in the filesystem is
> exactly what I want to avoid. Not because of reading problems, but to
> avoid wasting disk space. I don't have a reading problem. I have a
> writing problem.

If you've been using -o compress, then you should know that even then
not ALL data is compressed. If btrfs predicts that a data will be
unable to benefit frmo compression, it will store it uncompressed. The
problem is the prediction is not always right. Which is why there's -o
compress-force.

Anyway, for removable media case, there's a workaround that you can
use (at least it works with gnome). Put the entry for the usb block
device (e.g. /dev/sdb1) in fstab, with appropriate mount option, and
the option will be used when you mount it using nautilus.

-- 
Fajar
