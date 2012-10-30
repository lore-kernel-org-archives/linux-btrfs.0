Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59317 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab2J3XmD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 30 Oct 2012 19:42:03 -0400
Received: by mail-pb0-f46.google.com with SMTP id rr4so535217pbb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 30 Oct 2012 16:42:02 -0700 (PDT)
Message-ID: <509065C7.2030903@gmail.com>
Date: Wed, 31 Oct 2012 07:41:59 +0800
From: ching <lsching17@gmail.com>
MIME-Version: 1.0
To: cwillu <cwillu@cwillu.com>
CC: Felix Pepinghege <postfach@pepinghege.net>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Why btrfs inline small file by default?
References: <508FB45B.9040101@gmail.com> <508FC26A.1010206@pepinghege.net> <CAE5mzvhkrV9XD3_X_w_eLk7R4jrf4PxhEBJYTU7Hr6YtFDDd6Q@mail.gmail.com> <50904949.8010603@gmail.com> <CAE5mzvg4o6bfq9on_VdrWNzi3YCMBbusCfi9yicHecnuQTRB2w@mail.gmail.com>
In-Reply-To: <CAE5mzvg4o6bfq9on_VdrWNzi3YCMBbusCfi9yicHecnuQTRB2w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/31/2012 06:16 AM, cwillu wrote:
> On Tue, Oct 30, 2012 at 3:40 PM, ching <lsching17@gmail.com> wrote:
>> On 10/30/2012 08:17 PM, cwillu wrote:
>>>>> If there is a lot of small files, then the size of metadata will be
>>>>> undesirable due to deduplication
>>>> Yes, that is a fact, but if that really matters depends on the use-case
>>>> (e.g., the small files to large files ratio, ...). But as btrfs is designed
>>>> explicitly as a general purpose file system, you usually want the good
>>>> performance instead of the better disk-usage (especially as disk space isn't
>>>> expensive anymore).
>>> As I understand it, in basically all cases the total storage used by
>>> inlining will be _smaller_, as the allocation doesn't need to be
>>> aligned to the sector size.
>>>
>> if i have 10G small files in total, then it will consume 20G by default.
>>
>> ching
> No.  No they will not.  As I already explained.
>
> root@repository:/mnt$ mount ~/inline /mnt -o loop
> root@repository:/mnt$ mount ~/inline /mnt2 -o loop,max_inline=0
>
> root@repository:/mnt$ mount
> /dev/loop0 on /mnt type btrfs (rw)
> /dev/loop1 on /mnt2 type btrfs (rw,max_inline=0)
>
> root@repository:/mnt$ time for x in {1..243854}; do echo "some stuff"
>> /mnt/$x; done
> real	1m5.447s
> user	0m38.422s
> sys	0m18.493s
>
> root@repository:/mnt$ time for x in {1..243854}; do echo "some stuff"
>> /mnt2/$x; done
> real    1m49.880s
> user    0m40.379s
> sys     0m26.210s
>
> root@repository:/mnt$ df /mnt /mnt2
> Filesystem           1K-blocks      Used Available Use% Mounted on
> /dev/loop0            10485760    266952   8359680   4% /mnt
> /dev/loop1            10485760   1311620   7384236  16% /mnt2
>
> root@repository:/mnt$ btrfs fi df /mnt
> Data: total=1.01GB, used=256.00KB
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=130.22MB
> Metadata: total=8.00MB, used=0.00
>
> root@repository:/mnt$ btrfs fi df /mnt2
> Data: total=2.01GB, used=953.05MB
> System, DUP: total=8.00MB, used=4.00KB
> System: total=4.00MB, used=0.00
> Metadata, DUP: total=1.00GB, used=164.03MB
> Metadata: total=8.00MB, used=0.00
>
> root@repository:/mnt$ btrfs fi show
> Label: none  uuid: e5440337-9f44-4b2d-9889-80ab0ab8f245
> 	Total devices 1 FS bytes used 130.47MB
> 	devid    1 size 10.00GB used 3.04GB path /dev/loop0
>
> Label: none  uuid: cfcc4149-3102-465d-89b8-0a6bb6a4749a
> 	Total devices 1 FS bytes used 1.09GB
> 	devid    1 size 10.00GB used 4.04GB path /dev/loop1
>
> Btrfs Btrfs v0.19
>
> Any questions?
>

can the test be repeated for:
1. 3k per file with leaf size=4K
2. 60k per file with leaf size=64k


 
