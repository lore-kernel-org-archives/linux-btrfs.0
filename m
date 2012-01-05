From: Jan Schmidt <mail@jan-o-sch.net>
Subject: Re: [PATCH v2 00/10] Btrfs: backref walking rewrite
Date: Thu, 05 Jan 2012 10:54:07 +0100
Message-ID: <4F05733F.8070006@jan-o-sch.net>
References: <cover.1325692560.git.list.btrfs@jan-o-sch.net> <4F053754.2000805@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Schmidt <list.btrfs@jan-o-sch.net>, chris.mason@oracle.com,
	linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F053754.2000805@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 05.01.2012 06:38, Li Zefan wrote:
> Jan Schmidt wrote:
>> This patch series is a major rewrite of the backref walking code. The patch
>> series Arne sent some weeks ago for quota groups had a very interesting
>> function, find_all_roots. I took this from him together with the bits needed
>> for find_all_roots to work and replaced a major part of the code in backref.c
>> with it.
>>
>> It can be pulled from
>> 	git://git.jan-o-sch.net/btrfs-unstable for-chris
>> There's also a gitweb for that repo on
>> 	http://git.jan-o-sch.net/?p=btrfs-unstable
>>
> 
> Thanks for the work!
> 
> I got a compile warning:
> 
>   CC [M]  fs/btrfs/backref.o
> fs/btrfs/backref.c: In function 'inode_to_path':
> fs/btrfs/backref.c:1312:3: warning: format '%ld' expects type 'long int', but argument 3 has type 'int

Thanks for looking at this! Should now be fixed in my git repository
(involved another force-push). I won't resend by email unless requested.

-Jan
