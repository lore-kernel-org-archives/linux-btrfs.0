From: Arne Jansen <sensille@gmx.net>
Subject: Re: [RFC] Tree fragmentation and prefetching
Date: Thu, 24 Mar 2011 08:29:57 +0100
Message-ID: <4D8AF2F5.7040108@gmx.net>
References: <4D89F03A.9050306@gmx.net> <AANLkTinFUE0ALLABD0cirkMMAXrmz=m8juz+xEL8UBFJ@mail.gmail.com> <4D8A57E9.6010107@gmx.net> <4D8AA0AA.5010006@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Chris Mason <chris.mason@oracle.com>
To: miaox@cn.fujitsu.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D8AA0AA.5010006@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 24.03.2011 02:38, Miao Xie wrote:
> On wed, 23 Mar 2011 21:28:25 +0100, Arne Jansen wrote:
>> On 23.03.2011 20:26, Andrey Kuzmin wrote:
>>> On Wed, Mar 23, 2011 at 4:06 PM, Arne Jansen<sensille@gmx.net>  wrote:
>>>> The main idea is to load the tree (or parts of it) top-down, order the
>>>> needed blocks and distribute it over all disks.
>>>> To keep you interested, some results first.
>>>>
>>>> a) by tree enumeration with reada=2
>>>>    reading extent tree: 242s
>>>>    reading csum tree: 140s
>>>>    reading both trees: 324s
>>>>
>>>> b) prefetch prototype
>>>>    reading extent tree: 23.5s
>>>>    reading csum tree: 20.4s
>>>>    reading both trees: 25.7s
>>>
>>> 10x speed-up looks indeed impressive. Just for me to be sure, did I
>>> get you right in that you attribute this effect specifically to
>>> enumerating tree leaves in key address vs. disk addresses when these
>>> two are not aligned?
>>
>> Yes. Leaves and the intermediate nodes tend to be quite scattered
>> around the disk with respect to their logical order.
>> Reading them in logical (ascending/descending) order require lots
>> of seeks.
> 
> I'm also dealing with tree fragmentation problem, I try to store the leaves
> which have the same parent closely.

That's good to hear. Do you have already anything I can repeat the test
with?

-Arne

> 
> Regards
> Miao
> 
