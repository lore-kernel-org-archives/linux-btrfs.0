Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:37040 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965138AbdACXxi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 Jan 2017 18:53:38 -0500
Subject: Re: [markfasheh/duperemove] Why blocksize is limit to 1MB?
To: Peter Becker <floyd.net@gmail.com>
References: <CAEtw4r0-wgdQj4nO9HxCFvzXpRVhU=nqcKxRmDUsFVBuVrfong@mail.gmail.com>
 <0d0a4169-8c09-56c5-a052-0c894c46081c@gmail.com>
 <CAEtw4r2hU74Qfa_6X=y5hNQSq-yN9y=9wpAF7CjRgVP2p=ns-w@mail.gmail.com>
 <69d0539f-6cb4-644f-2e7e-16bb1575052e@mendix.com>
 <CAEtw4r1-WwLiK2trAWNJMwFRP2shOS+hemSNWMbKWAd-FBQrKw@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <624c67f5-6039-0332-fdea-19d6a80074ec@mendix.com>
Date: Wed, 4 Jan 2017 00:43:19 +0100
MIME-Version: 1.0
In-Reply-To: <CAEtw4r1-WwLiK2trAWNJMwFRP2shOS+hemSNWMbKWAd-FBQrKw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/04/2017 12:12 AM, Peter Becker wrote:
> Good hint, this would be an option and i will try this.
> 
> Regardless of this the curiosity has packed me and I will try to
> figure out where the problem with the low transfer rate is.
> 
> 2017-01-04 0:07 GMT+01:00 Hans van Kranenburg <hans.van.kranenburg@mendix.com>:
>> On 01/03/2017 08:24 PM, Peter Becker wrote:
>>> All invocations are justified, but not relevant in (offline) backup
>>> and archive scenarios.
>>>
>>> For example you have multiple version of append-only log-files or
>>> append-only db-files (each more then 100GB in size), like this:
>>>
>>>> Snapshot_01_01_2017
>>> -> file1.log .. 201 GB
>>>
>>>> Snapshot_02_01_2017
>>> -> file1.log .. 205 GB
>>>
>>>> Snapshot_03_01_2017
>>> -> file1.log .. 221 GB
>>>
>>> The first 201 GB would be every time the same.
>>> Files a copied at night from windows, linux or bsd systems and
>>> snapshoted after copy.
>>
>> XY problem?
>>
>> Why not use rsync --inplace in combination with btrfs snapshots? Even if
>> the remote does not support rsync and you need to pull the full file
>> first, you could again use rsync locally.

<annoyed>please don't toppost</annoyed>

Also, there is a rather huge difference in the two approaches, given the
way how btrfs works internally.

Say, I have a subvolume with thousands of directories and millions of
files with random data in it, and I want to have a second deduped copy
of it.

Approach 1:

Create a full copy of everything (compare: retrieving remote file again)
(now 200% of data storage is used), and after that do deduplication, so
that again only 100% of data storage is used.

Approach 2:

cp -av --reflink original/ copy/

By doing this, you end up with the same as doing approach 1 if your
deduper is the most ideal in the world (and the files are so random they
don't contain duplicate blocks inside them).

Approach 3:

btrfs sub snap original copy

W00t, that was fast, and the only thing that happened was writing a few
16kB metadata pages again. (1 for the toplevel tree page that got cloned
into a new filesystem tree, and a few for the blocks one level lower to
add backreferences to the new root).

So:

The big difference in the end result between approach 1,2 and otoh 3 is
that while deduplicating your data, you're actually duplicating all your
metadata at the same time.

In your situation, if possible doing an rsync --inplace from the remote,
so that only changed appended data gets stored, and then useing native
btrfs snapshotting it would seem the most effective.

-- 
Hans van Kranenburg
