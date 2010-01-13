From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: Metadata Duplication on a Single Disk Btrfs Setup
Date: Wed, 13 Jan 2010 16:17:35 -0600
Message-ID: <26a1f7961001131417h6ecbe5b6lfe4b19a2185b6b6a@mail.gmail.com>
References: <26a1f7961001121008u2d55eacobf2efd7a8ad39c7c@mail.gmail.com>
	 <4B4CBF28.6010602@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: jim owens <jowens@hp.com>, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4B4CBF28.6010602@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 12, 2010 at 12:27 PM, jim owens <jowens@hp.com> wrote:
> Mitch Harder wrote:
>> On a single disk btrfs setup, such as for a desktop computer, what a=
re
>> the implecations of creating your btrfs partition with '-m single'?
>>
>> At first, I assumed I would want a single disk desktop setup to be
>> configured as 'single'. =A0But that may not be the case for metadata=
=2E
>>
>> I see that the default is for metadata duplication in a single disk =
scenario.
>>
>> Is duplication of the metadata important for recovery from common
>> desktop user problems such as power interruption?
>
> Duplication of metadata protects against unreadable disk blocks
> or disk blocks that have garbage written in them. Power interruption
> can cause that in rare cases (and on some hardware not so rare).
>
> The more usual power loss issue is incomplete or stale data. =A0Even
> single metadata mode should protect from that.
>
> So the short answer is it provides some additional protection
> at the expense of more space used. =A0How much you need that extra
> protection depends on your hardware, power reliability, and how
> valuable your data is.
>
> jim
>

To satisfy my curiosity, I did a series of kernel compilation
comparisons on freshly formatted partitions with and without '-m
single -d single', and with and without compression.  I also added in
a control run on the same partition with default ext4 formatting.

I did not see much difference between the disk usage when disabling
metadata duplication.

I was also surprised to see so little difference in compile time
between the different cases.  I guess most of the files remained in
cache.

Here's a summary of my results:

Case #1: Ext4 control case
Case #2: Btrfs (mkfs defaults, no compression)
Case #3: Btrfs (Single metadata (& data), no compression)
Case #4: Btrfs (mkfs defaults, with compression)
Case #5: Btrfs (Single metadata (& data), with compression)

Case          (time make -j3)     1k blocks Used
Case #1        24m45.857s           1370140
Case #2        24m49.270s           1182080
Case #3        24m47.637s           1181932
Case #4        24m54.318s            477592
Case #5        24m54.720s            477744
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
