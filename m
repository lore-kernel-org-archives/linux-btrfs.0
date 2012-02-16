From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
Subject: Re: Premature ENOSPC only with zlib Compression
Date: Thu, 16 Feb 2012 16:05:40 +0100
Message-ID: <CAFDW0jJgNxNXJHiJxur+QaPAioyAyZ+-ftnTtZ2rR69Tqy0bfw@mail.gmail.com>
References: <CAKcLGm--EKeAbw7JzBtv7snhXEJSzTMZjn9_QDT+jGRCWsjM2g@mail.gmail.com>
	<CAFDW0jLfLtEpnijsratvGho8RzC9D7nJD8H2y0SdZ6AxYeGpYw@mail.gmail.com>
	<201202162131.38463.chris@csamuel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Chris Samuel <chris@csamuel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201202162131.38463.chris@csamuel.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 16, 2012 at 11:31 AM, Chris Samuel <chris@csamuel.org> wrote:
> On Thursday 16 February 2012 19:06:52 Ahmet Inan wrote:
>
>> and got ENOSPC again :(
>>
>> so it doesnt matter if lzo or zlib: ENOSPC with compression
>> enabled!
>>
>> my kernel: vanilla 3.2.5
>
> I know that there has been an ENOSPC fix go in to the 3.3 RC kernels
> since the 3.2 release, any chance you'd be able to see if it still
> happens with the current 3.3 RC ?

just tested 3.3.0-rc3, and it works like a charm!

but there are lots of issues with external packages not compiling with 3.3,
why i wont be able to deploy it to our systems here yet.

could this one bugfix be backported to 3.2?

here are some results from my unsquashfs'ing just to show how
awesome btrfs with lzo is. these results are _not_ from an ssd btw!
(spinning disks, rebooted between tests)

# time unsquashfs /dev/nbd0
Parallel unsquashfs: Using 8 processors
792630 inodes (870469 blocks) to write

[==================/] 870469/870469 100%
created 759645 files
created 67271 directories
created 27250 symlinks
created 5141 devices
created 0 fifos

Timing Results:

zlib:
real    6m38.586s
user    2m16.021s
sys     0m31.138s

lzo:
real    1m53.429s
user    1m55.622s
sys     0m46.664s

no compression:
real    1m16.975s
user    1m47.173s
sys     0m53.520s

complete system installation in under 5minutes, that simply rocks!

Ahmet
