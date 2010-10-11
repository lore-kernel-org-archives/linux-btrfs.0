From: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: Horrible btrfs performance on cold cache
Date: Tue, 12 Oct 2010 00:01:35 +0300
Message-ID: <AANLkTinaJU_=MuCcefOweED5g2HMpHjUra8nR6mBdoyR@mail.gmail.com>
References: <AANLkTin8mAaHz_PypS9j4vQ35WozgD==U493e3OW_sy2@mail.gmail.com>
	<1286811979.9645.5.camel@ayu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Calvin Walton <calvin.walton@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1286811979.9645.5.camel@ayu>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 11, 2010 at 6:46 PM, Calvin Walton <calvin.walton@gmail.com> wrote:
> On Mon, 2010-10-11 at 03:30 +0300, Felipe Contreras wrote:
>> I use btrfs on most of my volumes on my laptop, and I've always felt
>> booting was very slow, but definitely sure is slow, is starting up
>> Google Chrome:
>>
>> encrypted ext4: ~20s
>> btrfs: ~2:11s
>>
>> I have tried different things to find out exactly what is the issue,
>> but haven't quite found it yet.
>
> If you've been using this volume for a while, it could just have become
> badly fragmented. You could try btrfs's fancy online defragmentation
> abilities to see if that'll give you an improvement:
>
> # btrfs filesystem defragment /mountpoint/of/volume
>
> Let us know if that helps, of course :)

~2:06s, so it helped a bit, but not much really, there's still
something fishy going on.

-- 
Felipe Contreras
