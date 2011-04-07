From: Jordan Patterson <jordanp@gmail.com>
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Thu, 7 Apr 2011 09:44:18 -0600
Message-ID: <BANLkTikCYEHgG85d8E9ONs8zhwF+A63kYQ@mail.gmail.com>
References: <201104051938.14319.johannes.hirte@fem.tu-ilmenau.de>
	<201104060000.11403.johannes.hirte@fem.tu-ilmenau.de>
	<20110405215752.GE484@dhcp231-156.rdu.redhat.com>
	<201104061310.38951.johannes.hirte@fem.tu-ilmenau.de>
	<20110406171541.GA5574@localhost.localdomain>
	<BANLkTi=hZ2i-kj70yq+=E74oSZZu9G7wtw@mail.gmail.com>
	<20110407131712.GF484@dhcp231-156.rdu.redhat.com>
	<BANLkTin1MN-QZWGvVE4o0T1_U9B1qtunig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTin1MN-QZWGvVE4o0T1_U9B1qtunig@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 7, 2011 at 9:44 AM, Jordan Patterson <jordanp@gmail.com> wr=
ote:
> On Thu, Apr 7, 2011 at 7:17 AM, Josef Bacik <josef@redhat.com> wrote:
>> On Wed, Apr 06, 2011 at 02:47:28PM -0600, Jordan Patterson wrote:
>>> Hi Josef:
>>>
>>> I tried your latest patch, since I had the same issue from the firs=
t
>>> email. =A0With the patch applied, I am now hitting the
>>> BUG_ON(block_group->total_bitmaps >=3D max_bitmaps); in add_new_bit=
map
>>> in
>>> fs/btrfs/free-space-cache.c:1246 as soon as I mount the filesystem,
>>> with or without -o clear_cache.
>>>
>>> It works fine in 2.6.38. =A0I get the same error after mounting wit=
h
>>> clear_cache under 2.6.38 and rebooting into the current kernel with
>>> your patch.
>>>
>>
>> Do you have a backtrace so I can see how we're getting here? =A0This=
 is a seperate
>> issue from the one this patch tries to solve, but now that it seems =
that's fixed
>> I will work on this now :). =A0Thanks,
>>
>> Josef
>>
>
> I wasn't able to test until now, but Johannes' suggestion may have
> fixed the issue for me. =A0I added clear_cache to my rootflags in gru=
b,
> and it is now mounted fine with the current btrfs code with your last
> patch. =A0I don't have the backtrace, but I'll send it to you it if I
> see it happen again.
>
> Thanks.
>
> Jordan
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
