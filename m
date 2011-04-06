From: Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH] Btrfs: don't kzalloc the ordered extents
Date: Wed, 06 Apr 2011 11:24:31 -0400
Message-ID: <4D9C85AF.2040008@redhat.com>
References: <1302045649-1580-1-git-send-email-josef@redhat.com> <4D9C1C1F.8090208@gmx.net> <1302087945-sup-6943@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Arne Jansen <sensille@gmx.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1302087945-sup-6943@think>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/06/2011 07:06 AM, Chris Mason wrote:
> Excerpts from Arne Jansen's message of 2011-04-06 03:54:07 -0400:
>> On 06.04.2011 01:20, Josef Bacik wrote:
>>> We initialize almost all of the fields when we allocate an ordered extent, so
>>> use kmalloc instead of kzalloc and just initialize the other fields that we
>>> don't already initialize yet.  Thanks,
>> Is it really worth it? we have seen a few bugs in the past resulting
>> from uninitialized structure element, that even made it to disk.
>> Using kzalloc makes maintenance much easier.
> I'm a big kzalloc fan unless this particular caller shows up in
> benchmarks.  Josef how much did this one help?
>
> -chris
.1 mb/s, give or take .1 mb/s :).  Just low hanging fruit since we're 
already doing all the initialization anyway, but it's up to you, kind of 
just was fixing everything I could get my hands on :).  Thanks,

Josef
