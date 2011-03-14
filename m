From: Arne Jansen <sensille@gmx.net>
Subject: Re: [PATCH v3 3/6] btrfs: add scrub code and prototypes
Date: Mon, 14 Mar 2011 10:57:05 +0100
Message-ID: <4D7DE671.70304@gmx.net>
References: <cover.1299941055.git.sensille@gmx.net> <7ccafb5250b72ca706369a8d5b45f06e8d5a4f8a.1299941055.git.sensille@gmx.net> <20110313235031.GA32690@kwango.lan.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org
To: Ilya Dryomov <idryomov@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110313235031.GA32690@kwango.lan.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 14.03.2011 00:50, Ilya Dryomov wrote:
> On Sat, Mar 12, 2011 at 03:50:42PM +0100, Arne Jansen wrote:
>> This is the main scrub code.

>> +	int nstripes;
>
> It should be u64 nstripes.  A few lines below you assign the stripe
> length, it is a 64 bit quantity, also do_div() expects a 64 bit
> dividend.  This fixes a serious breakage on x86-32.

Thanks.

>
> Overall, this function could use a good cleanup.  I can send you a patch
> later unless you want to do it yourself.

Which parts do you have in mind? I see only potential for minor cleanup,
but as I wrote it, I might as well be blind to it ;) So when you
send the patch I'll probably see what you mean.
The part I'm not content with is the prefetching, as it is still too
slow.

>
>> +	int start_stripe;
>> +	struct extent_buffer *l;
>> +	struct btrfs_key key;
>> +	u64 physical;
>> +	u64 logical;
>> +	u64 generation;
>> +	u64 mirror_num;
>
> And a minor thing on the whole series: u64 should be printed with %llu
> and explicit casting to unsigned long long.

fixed.

>
> Thanks,
>
> 		Ilya
>
>> --
