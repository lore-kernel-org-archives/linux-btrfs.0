Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:52700 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab3LQIaM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 03:30:12 -0500
Received: by mail-oa0-f44.google.com with SMTP id m1so6270738oag.3
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 00:30:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <D3F43FCF-1262-4324-B342-7DB2359B12FD@colorremedies.com>
References: <CAO5znau9bYtjLmcwSE9uD7tRo0uY_CLHhLNCoYW7cpRLJtve-g@mail.gmail.com>
	<ABF7C191-D33A-4DE2-9E31-D44B7CE16475@colorremedies.com>
	<CAO5znatm9bKq2a3WBSAZTEPjHQgS3DZpRwGY7pDsyN9J1WsWNQ@mail.gmail.com>
	<D3F43FCF-1262-4324-B342-7DB2359B12FD@colorremedies.com>
Date: Tue, 17 Dec 2013 09:30:11 +0100
Message-ID: <CAO5znavUobuaWtUXhm2eYyuj+KfFVrh5k5Lz_PaHrxYrzhxG7w@mail.gmail.com>
Subject: Re: Understanding subvolume hierarchy
From: Nicolas Michel <be.nicolas.michel@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Mhmm. Thanks. I'm begining to understand ;)
Still : how can I see/know that id 5 is mapped to id 0 ? And why doing
this? For what purpose? (is it a default btrfs behavior or is it set
by the Ubuntu installer?)

2013/12/17 Chris Murphy <lists@colorremedies.com>:
>
> On Dec 16, 2013, at 4:54 PM, Nicolas Michel <be.nicolas.michel@gmail.com> wrote:
>
>> OK. thanks for your pretty fast answer :)
>>
>> Now my last question is: in this case it was "easy" as I know that I
>> created all these subvolumes as parts of volume 0. But in the btrfs
>> subv list / I don't see any information that tells me they belongs to
>> id 0. If I have to debug a server/desktop and I don't know the
>> hierarchy that has been made, how can I know that my tmp subvolume is
>> indeed a child of id 0 ?
>
> When you do a subvol list it shows you what its top level is. Example:
>
>
>
> # btrfs subvol list /
> ID 256 gen 1047 top level 5 path root
> ID 258 gen 983 top level 5 path home
> ID 259 gen 983 top level 5 path data
> ID 276 gen 1012 top level 5 path root_ro
>
>
> root is mounted at /
> home is mounted at /hoome
> data is mounted at /data
> root_ro is not mounted at all
>
>
> #cd /data
> # btrfs subvol create data2
> Create subvolume './data2'
> # btrfs subvol list /
> ID 256 gen 1047 top level 5 path root
> ID 258 gen 983 top level 5 path home
> ID 259 gen 1048 top level 5 path data
> ID 276 gen 1012 top level 5 path root_ro
> ID 277 gen 1048 top level 5 path data/data2
>
> # btrfs subvol list /data
> ID 256 gen 1047 top level 5 path root
> ID 258 gen 983 top level 5 path home
> ID 259 gen 1048 top level 5 path data
> ID 276 gen 1012 top level 5 path root_ro
> ID 277 gen 1048 top level 259 path data2
>
>
> So notice that "top level 5 data/data2" means the same as "top level 259 data2" because top level 259 implies data.
>
> You can also use btrfs subvol show <subvol> and it will give you more information including whether it's a snapshot, what the parent is; and if it's a parent that has snapshots it'll list the snapshots.
>
> # btrfs subvol show /data
> /data
>         Name:                   data
>         uuid:                   bc45f4be-51c9-2848-bb68-d6e922b8e2bd
>         Parent uuid:            -
>         Creation time:          2013-12-12 16:18:13
>         Object ID:              259
>         Generation (Gen):       1048
>         Gen at creation:        11
>         Parent:                 5
>         Top Level:              5
>         Flags:                  -
>         Snapshot(s):
> # btrfs subvol show /data/data2
> /data/data2
>         Name:                   data2
>         uuid:                   a66eddf9-107f-0448-a021-da417a982827
>         Parent uuid:            -
>         Creation time:          2013-12-16 17:11:36
>         Object ID:              277
>         Generation (Gen):       1048
>         Gen at creation:        1048
>         Parent:                 259
>         Top Level:              259
>         Flags:                  -
>         Snapshot(s):
>
>
>
> Chris Murphy
>



-- 
Nicolas MICHEL
