Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36536 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753737AbdFSJGr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Jun 2017 05:06:47 -0400
Received: by mail-wm0-f68.google.com with SMTP id d17so15662224wme.3
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Jun 2017 02:06:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170601225729.GA3279@lim.localdomain>
References: <20170526002631.8546-1-bo.li.liu@oracle.com> <CAMG9ccwjBmP9HKkodwARxQK7AkC68HACMzuT43wX6+gmWVUjbg@mail.gmail.com>
 <20170601173510.GA22952@lim.localdomain> <CAMG9ccwxQn172kpUR61hp8OV_H+rRx4BQhRvMpUs4qn4DKic+Q@mail.gmail.com>
 <20170601225729.GA3279@lim.localdomain>
From: Ivan Sizov <sivan606@gmail.com>
Date: Mon, 19 Jun 2017 12:06:24 +0300
Message-ID: <CAMG9ccyVNvHijjEDNgTXGQcODGrY-0EwECNFL8szdgN8_-JN-Q@mail.gmail.com>
Subject: Re: [PATCH 0/6] add sanity check for extent inline ref type
To: Liu Bo <bo.li.liu@oracle.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2017-06-02 1:57 GMT+03:00 Liu Bo <bo.li.liu@oracle.com>:
> On Thu, Jun 01, 2017 at 11:26:26PM +0300, Ivan Sizov wrote:
>> 2017-06-01 20:35 GMT+03:00 Liu Bo <bo.li.liu@oracle.com>:
>> > After I went through the output of leaf's content, most parts of the
>> > leaf is sane except the two corrupted items, it's still not clear to
>> > me what caused the corruption, there could be some corner cases that
>> > I'm not aware of.
>> >
>> > If fsck doesn't work for you, then a recovery from backup may be the
>> > best option.
>>
>> I don't need to run any repair procedures because system is working
>> normally. Most likely that corrupted extents belong to files located
>> somewhere in /home.
>> Do you mean I should run fsck in order to determine which files are
>> corrupted? What are proper options to run fsck with?
>
> I see.  Scrub has found that there are some corrupted metadata, if you
> want to fix that corrupted thing, fsck may be helpful.  Due to my
> test, 'btrfs check /your_disk' fixed my corruption.
>
> With this patch set, at least you won't get a crash when accessing the
> corrupted extent inline ref.
>
> -liubo

After applying patchset I unwisely ran rsync and then FS became RW-unmountable.
"btrfs-check -p --readonly" gave me many errors of different types.
After "btrfs check -p --repair" I'd mounted the FS and ran scrub.
But not all errors was fixed and boot attempt caused RO-remounting again.

Now check gives this:

[liveuser@localhost-live ~]$ sudo btrfs check -p --readonly /dev/sda1
Checking filesystem on /dev/sda1
UUID: 4b30bf4a-2331-40fb-a108-e1a34aa14221
ref mismatch on [2398147911680 4096] extent item 12, found 13
Backref 2398147911680 root 27665 owner 17074270 offset 4096 num_refs 0
not found in extent tree
Incorrect local backref count on 2398147911680 root 27665 owner
17074270 offset 4096 found 1 wanted 0 back 0x562ce582c260
backpointer mismatch on [2398147911680 4096]
ref mismatch on [2398176096256 4096] extent item 12, found 13
Backref 2398176096256 root 27665 owner 17074270 offset 8192 num_refs 0
not found in extent tree
Incorrect local backref count on 2398176096256 root 27665 owner
17074270 offset 8192 found 1 wanted 0 back 0x562cd886b7f0
backpointer mismatch on [2398176096256 4096]
ref mismatch on [2398285246464 4096] extent item 12, found 13
Backref 2398285246464 root 27665 owner 17074270 offset 16384 num_refs
0 not found in extent tree
Incorrect local backref count on 2398285246464 root 27665 owner
17074270 offset 16384 found 1 wanted 0 back 0x562cd7e16900
backpointer mismatch on [2398285246464 4096]
ref mismatch on [2404820451328 16384] extent item 0, found 1
Backref 2404820451328 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2404820451328 16384]
owner ref check failed [2404820451328 16384]
ref mismatch on [2405008687104 16384] extent item 0, found 1
Backref 2405008687104 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2405008687104 16384]
owner ref check failed [2405008687104 16384]
ref mismatch on [2405015797760 16384] extent item 0, found 1
Backref 2405015797760 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2405015797760 16384]
owner ref check failed [2405015797760 16384]
ref mismatch on [2405036081152 16384] extent item 0, found 1
Backref 2405036081152 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2405036081152 16384]
owner ref check failed [2405036081152 16384]
ref mismatch on [2405057970176 16384] extent item 0, found 1
Backref 2405057970176 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2405057970176 16384]
owner ref check failed [2405057970176 16384]
ref mismatch on [2405176311808 16384] extent item 0, found 1
Backref 2405176311808 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2405176311808 16384]
owner ref check failed [2405176311808 16384]
ref mismatch on [2477885390848 16384] extent item 0, found 1
Backref 2477885390848 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2477885390848 16384]
owner ref check failed [2477885390848 16384]
ref mismatch on [2478010597376 16384] extent item 0, found 1
Backref 2478010597376 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2478010597376 16384]
ref mismatch on [2478014939136 16384] extent item 0, found 1
Backref 2478014939136 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2478014939136 16384]
owner ref check failed [2478014939136 16384]
ref mismatch on [2478015250432 16384] extent item 0, found 1
Backref 2478015250432 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2478015250432 16384]
ref mismatch on [2478640545792 16384] extent item 0, found 1
Backref 2478640545792 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2478640545792 16384]
ref mismatch on [2478698627072 16384] extent item 0, found 1
Backref 2478698627072 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2478698627072 16384]
ref mismatch on [2478754430976 16384] extent item 0, found 1
Backref 2478754430976 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2478754430976 16384]
ref mismatch on [2940674424832 16384] extent item 0, found 1
Backref 2940674424832 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2940674424832 16384]
ref mismatch on [2940696428544 16384] extent item 0, found 1
Backref 2940696428544 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2940696428544 16384]
ref mismatch on [2940722905088 16384] extent item 0, found 1
Backref 2940722905088 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2940722905088 16384]
ref mismatch on [2940747988992 16384] extent item 0, found 1
Backref 2940747988992 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2940747988992 16384]
ref mismatch on [2940822536192 16384] extent item 0, found 1
Backref 2940822536192 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2940822536192 16384]
owner ref check failed [2940822536192 16384]
ref mismatch on [2940824911872 16384] extent item 0, found 1
Backref 2940824911872 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2940824911872 16384]
ref mismatch on [2940983296000 16384] extent item 0, found 1
Backref 2940983296000 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2940983296000 16384]
ref mismatch on [2940986081280 16384] extent item 0, found 1
Backref 2940986081280 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2940986081280 16384]
owner ref check failed [2940986081280 16384]
ref mismatch on [2941004644352 16384] extent item 0, found 1
Backref 2941004644352 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2941004644352 16384]
owner ref check failed [2941004644352 16384]
ref mismatch on [2941128359936 16384] extent item 0, found 1
Backref 2941128359936 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2941128359936 16384]
ref mismatch on [2941445341184 16384] extent item 0, found 1
Backref 2941445341184 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2941445341184 16384]
ref mismatch on [2941549592576 16384] extent item 0, found 1
Backref 2941549592576 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2941549592576 16384]
ref mismatch on [2993876762624 16384] extent item 0, found 1
Backref 2993876762624 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2993876762624 16384]
owner ref check failed [2993876762624 16384]
ref mismatch on [2993898897408 16384] extent item 0, found 1
Backref 2993898897408 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2993898897408 16384]
ref mismatch on [2993900093440 16384] extent item 0, found 1
Backref 2993900093440 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2993900093440 16384]
ref mismatch on [2993900683264 16384] extent item 0, found 1
Backref 2993900683264 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2993900683264 16384]
ref mismatch on [2993901322240 16384] extent item 0, found 1
Backref 2993901322240 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [2993901322240 16384]
owner ref check failed [2993901322240 16384]
ref mismatch on [4136696893440 8192] extent item 12, found 13
Backref 4136696893440 root 27665 owner 17074280 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 4136696893440 root 27665 owner
17074280 offset 0 found 1 wanted 0 back 0x562c82762130
backpointer mismatch on [4136696893440 8192]
ref mismatch on [4136751419392 12288] extent item 12, found 13
Backref 4136751419392 root 27665 owner 17074272 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 4136751419392 root 27665 owner
17074272 offset 0 found 1 wanted 0 back 0x562c96c163b0
backpointer mismatch on [4136751419392 12288]
ref mismatch on [4160214544384 8192] extent item 12, found 13
Backref 4160214544384 root 27665 owner 17074273 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 4160214544384 root 27665 owner
17074273 offset 0 found 1 wanted 0 back 0x562c8fee4770
backpointer mismatch on [4160214544384 8192]
ref mismatch on [4160523833344 8192] extent item 12, found 13
Backref 4160523833344 root 27665 owner 17074251 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 4160523833344 root 27665 owner
17074251 offset 0 found 1 wanted 0 back 0x562ce818bd20
backpointer mismatch on [4160523833344 8192]
ref mismatch on [4160696741888 8192] extent item 12, found 13
Backref 4160696741888 root 27665 owner 17074274 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 4160696741888 root 27665 owner
17074274 offset 0 found 1 wanted 0 back 0x562c8276fb90
backpointer mismatch on [4160696741888 8192]
ref mismatch on [4160697847808 8192] extent item 12, found 13
Backref 4160697847808 root 27665 owner 17074277 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 4160697847808 root 27665 owner
17074277 offset 0 found 1 wanted 0 back 0x562cd7e0dd60
backpointer mismatch on [4160697847808 8192]
ref mismatch on [4160726593536 8192] extent item 12, found 13
Backref 4160726593536 root 27665 owner 17074279 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 4160726593536 root 27665 owner
17074279 offset 0 found 1 wanted 0 back 0x562c74ae8550
backpointer mismatch on [4160726593536 8192]
ref mismatch on [4162150592512 16384] extent item 12, found 13
Backref 4162150592512 root 27665 owner 17074275 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 4162150592512 root 27665 owner
17074275 offset 0 found 1 wanted 0 back 0x562cc9365b00
backpointer mismatch on [4162150592512 16384]
ref mismatch on [4162151714816 36864] extent item 12, found 13
Backref 4162151714816 root 27665 owner 17074271 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 4162151714816 root 27665 owner
17074271 offset 0 found 1 wanted 0 back 0x562cd0952590
backpointer mismatch on [4162151714816 36864]
ref mismatch on [4162183225344 12288] extent item 12, found 13
Backref 4162183225344 root 27665 owner 17074257 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 4162183225344 root 27665 owner
17074257 offset 0 found 1 wanted 0 back 0x562c7f46aba0
backpointer mismatch on [4162183225344 12288]
ref mismatch on [4163704074240 28672] extent item 12, found 13
Backref 4163704074240 root 27665 owner 17074276 offset 0 num_refs 0
not found in extent tree
Incorrect local backref count on 4163704074240 root 27665 owner
17074276 offset 0 found 1 wanted 0 back 0x562ce22465d0
backpointer mismatch on [4163704074240 28672]
ref mismatch on [4197053726720 16384] extent item 0, found 1
Backref 4197053726720 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4197053726720 16384]
ref mismatch on [4240053813248 16384] extent item 0, found 1
Backref 4240053813248 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4240053813248 16384]
owner ref check failed [4240053813248 16384]
ref mismatch on [4240128278528 16384] extent item 0, found 1
Backref 4240128278528 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4240128278528 16384]
owner ref check failed [4240128278528 16384]
ref mismatch on [4240269213696 16384] extent item 0, found 1
Backref 4240269213696 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4240269213696 16384]
owner ref check failed [4240269213696 16384]
ref mismatch on [4240361209856 16384] extent item 0, found 1
Backref 4240361209856 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4240361209856 16384]
owner ref check failed [4240361209856 16384]
ref mismatch on [4240424173568 16384] extent item 0, found 1
Backref 4240424173568 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4240424173568 16384]
owner ref check failed [4240424173568 16384]
ref mismatch on [4537701056512 16384] extent item 0, found 1
Backref 4537701056512 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4537701056512 16384]
owner ref check failed [4537701056512 16384]
ref mismatch on [4627734691840 16384] extent item 0, found 1
Backref 4627734691840 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4627734691840 16384]
owner ref check failed [4627734691840 16384]
ref mismatch on [4627984351232 16384] extent item 0, found 1
Backref 4627984351232 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4627984351232 16384]
owner ref check failed [4627984351232 16384]
ref mismatch on [4627986448384 16384] extent item 0, found 1
Backref 4627986448384 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4627986448384 16384]
ref mismatch on [4628658339840 16384] extent item 0, found 1
Backref 4628658339840 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4628658339840 16384]
owner ref check failed [4628658339840 16384]
ref mismatch on [4628876689408 16384] extent item 0, found 1
Backref 4628876689408 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4628876689408 16384]
owner ref check failed [4628876689408 16384]
ref mismatch on [4629238202368 16384] extent item 0, found 1
Backref 4629238202368 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4629238202368 16384]
owner ref check failed [4629238202368 16384]
ref mismatch on [4629301755904 16384] extent item 0, found 1
Backref 4629301755904 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4629301755904 16384]
owner ref check failed [4629301755904 16384]
ref mismatch on [4629365145600 16384] extent item 0, found 1
Backref 4629365145600 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4629365145600 16384]
owner ref check failed [4629365145600 16384]
ref mismatch on [4629365866496 16384] extent item 0, found 1
Backref 4629365866496 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4629365866496 16384]
ref mismatch on [4629424128000 16384] extent item 0, found 1
Backref 4629424128000 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4629424128000 16384]
owner ref check failed [4629424128000 16384]
ref mismatch on [4629463187456 16384] extent item 0, found 1
Backref 4629463187456 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4629463187456 16384]
owner ref check failed [4629463187456 16384]
ref mismatch on [4629721989120 16384] extent item 0, found 1
Backref 4629721989120 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4629721989120 16384]
ref mismatch on [4631433773056 16384] extent item 0, found 1
Backref 4631433773056 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4631433773056 16384]
owner ref check failed [4631433773056 16384]
ref mismatch on [4631637868544 16384] extent item 0, found 1
Backref 4631637868544 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4631637868544 16384]
owner ref check failed [4631637868544 16384]
ref mismatch on [4632167563264 16384] extent item 0, found 1
Backref 4632167563264 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4632167563264 16384]
owner ref check failed [4632167563264 16384]
ref mismatch on [4632548638720 16384] extent item 0, found 1
Backref 4632548638720 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4632548638720 16384]
owner ref check failed [4632548638720 16384]
ref mismatch on [4632727863296 16384] extent item 0, found 1
Backref 4632727863296 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4632727863296 16384]
owner ref check failed [4632727863296 16384]
ref mismatch on [4633126191104 16384] extent item 0, found 1
Backref 4633126191104 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4633126191104 16384]
owner ref check failed [4633126191104 16384]
ref mismatch on [4634633502720 16384] extent item 0, found 1
Backref 4634633502720 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4634633502720 16384]
owner ref check failed [4634633502720 16384]
ref mismatch on [4637186506752 16384] extent item 0, found 1
Backref 4637186506752 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4637186506752 16384]
ref mismatch on [4656113008640 16384] extent item 0, found 1
Backref 4656113008640 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4656113008640 16384]
ref mismatch on [4656480239616 16384] extent item 0, found 1
Backref 4656480239616 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4656480239616 16384]
ref mismatch on [4656519987200 16384] extent item 0, found 1
Backref 4656519987200 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4656519987200 16384]
ref mismatch on [4656523427840 16384] extent item 0, found 1
Backref 4656523427840 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4656523427840 16384]
ref mismatch on [4656548888576 16384] extent item 0, found 1
Backref 4656548888576 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4656548888576 16384]
ref mismatch on [4656708648960 16384] extent item 0, found 1
Backref 4656708648960 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4656708648960 16384]
ref mismatch on [4656790257664 16384] extent item 0, found 1
Backref 4656790257664 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4656790257664 16384]
ref mismatch on [4656802725888 16384] extent item 0, found 1
Backref 4656802725888 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4656802725888 16384]
ref mismatch on [4656806215680 16384] extent item 0, found 1
Backref 4656806215680 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4656806215680 16384]
owner ref check failed [4656806215680 16384]
ref mismatch on [4656806264832 16384] extent item 0, found 1
Backref 4656806264832 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4656806264832 16384]
ref mismatch on [4656880435200 16384] extent item 0, found 1
Backref 4656880435200 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4656880435200 16384]
ref mismatch on [4657100341248 16384] extent item 0, found 1
Backref 4657100341248 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4657100341248 16384]
owner ref check failed [4657100341248 16384]
ref mismatch on [4736962412544 16384] extent item 0, found 1
Backref 4736962412544 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4736962412544 16384]
owner ref check failed [4736962412544 16384]
ref mismatch on [4737106657280 16384] extent item 0, found 1
Backref 4737106657280 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4737106657280 16384]
owner ref check failed [4737106657280 16384]
ref mismatch on [4737143046144 16384] extent item 0, found 1
Backref 4737143046144 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4737143046144 16384]
owner ref check failed [4737143046144 16384]
ref mismatch on [4737511571456 16384] extent item 0, found 1
Backref 4737511571456 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4737511571456 16384]
owner ref check failed [4737511571456 16384]
ref mismatch on [4850508398592 16384] extent item 0, found 1
Backref 4850508398592 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850508398592 16384]
owner ref check failed [4850508398592 16384]
ref mismatch on [4850566594560 16384] extent item 0, found 1
Backref 4850566594560 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850566594560 16384]
owner ref check failed [4850566594560 16384]
ref mismatch on [4850593333248 16384] extent item 0, found 1
Backref 4850593333248 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850593333248 16384]
owner ref check failed [4850593333248 16384]
ref mismatch on [4850611699712 16384] extent item 0, found 1
Backref 4850611699712 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850611699712 16384]
owner ref check failed [4850611699712 16384]
ref mismatch on [4850617221120 16384] extent item 0, found 1
Backref 4850617221120 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850617221120 16384]
owner ref check failed [4850617221120 16384]
ref mismatch on [4850644107264 16384] extent item 0, found 1
Backref 4850644107264 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850644107264 16384]
owner ref check failed [4850644107264 16384]
ref mismatch on [4850652495872 16384] extent item 0, found 1
Backref 4850652495872 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850652495872 16384]
owner ref check failed [4850652495872 16384]
ref mismatch on [4850707054592 16384] extent item 0, found 1
Backref 4850707054592 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850707054592 16384]
owner ref check failed [4850707054592 16384]
ref mismatch on [4850708873216 16384] extent item 0, found 1
Backref 4850708873216 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850708873216 16384]
ref mismatch on [4850785501184 16384] extent item 0, found 1
Backref 4850785501184 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850785501184 16384]
owner ref check failed [4850785501184 16384]
ref mismatch on [4850785615872 16384] extent item 0, found 1
Backref 4850785615872 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850785615872 16384]
owner ref check failed [4850785615872 16384]
ref mismatch on [4850794332160 16384] extent item 0, found 1
Backref 4850794332160 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850794332160 16384]
owner ref check failed [4850794332160 16384]
ref mismatch on [4850805620736 16384] extent item 0, found 1
Backref 4850805620736 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850805620736 16384]
owner ref check failed [4850805620736 16384]
ref mismatch on [4850829279232 16384] extent item 0, found 1
Backref 4850829279232 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850829279232 16384]
owner ref check failed [4850829279232 16384]
ref mismatch on [4850840502272 16384] extent item 0, found 1
Backref 4850840502272 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850840502272 16384]
ref mismatch on [4850840600576 16384] extent item 0, found 1
Backref 4850840600576 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850840600576 16384]
owner ref check failed [4850840600576 16384]
ref mismatch on [4850847301632 16384] extent item 0, found 1
Backref 4850847301632 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850847301632 16384]
ref mismatch on [4850848530432 16384] extent item 0, found 1
Backref 4850848530432 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850848530432 16384]
ref mismatch on [4850874925056 16384] extent item 0, found 1
Backref 4850874925056 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850874925056 16384]
owner ref check failed [4850874925056 16384]
ref mismatch on [4850921144320 16384] extent item 0, found 1
Backref 4850921144320 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850921144320 16384]
owner ref check failed [4850921144320 16384]
ref mismatch on [4850931351552 16384] extent item 0, found 1
Backref 4850931351552 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [4850931351552 16384]
owner ref check failed [4850931351552 16384]
ref mismatch on [5168610377728 16384] extent item 0, found 1
Backref 5168610377728 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [5168610377728 16384]
owner ref check failed [5168610377728 16384]
ref mismatch on [5168614178816 16384] extent item 0, found 1
Backref 5168614178816 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [5168614178816 16384]
owner ref check failed [5168614178816 16384]
ref mismatch on [5168624861184 16384] extent item 0, found 1
Backref 5168624861184 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [5168624861184 16384]
owner ref check failed [5168624861184 16384]
ref mismatch on [5168696754176 16384] extent item 0, found 1
Backref 5168696754176 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [5168696754176 16384]
owner ref check failed [5168696754176 16384]
ref mismatch on [5168913530880 16384] extent item 0, found 1
Backref 5168913530880 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [5168913530880 16384]
owner ref check failed [5168913530880 16384]
ref mismatch on [5168913580032 16384] extent item 0, found 1
Backref 5168913580032 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [5168913580032 16384]
owner ref check failed [5168913580032 16384]
ref mismatch on [5169032200192 16384] extent item 0, found 1
Backref 5169032200192 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [5169032200192 16384]
owner ref check failed [5169032200192 16384]
ref mismatch on [5169189437440 16384] extent item 0, found 1
Backref 5169189437440 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [5169189437440 16384]
owner ref check failed [5169189437440 16384]
ref mismatch on [5169234214912 16384] extent item 0, found 1
Backref 5169234214912 parent 27641 root 27641 not found in extent tree
backpointer mismatch on [5169234214912 16384]
owner ref check failed [5169234214912 16384]

checking free space cache [o]
checkingunresolved ref dir 17093096 index 2 namelen 8 name 15186792
filetype 1 errors 80, filetype mismatch
checkingunresolved ref dir 17124053 index 2 namelen 8 name 15186792
filetype 1 errors 80, filetype mismatch
checkingunresolved ref dir 17133579 index 2 namelen 8 name 15186792
filetype 1 errors 80, filetype mismatch
checking fs roots [.]
found 2804232417285 bytes used err is 1
total csum bytes: 2314569220
total tree bytes: 30477664256
total fs tree bytes: 27351531520
total extent tree bytes: 574193664
btree space waste bytes: 4508064476
file data blocks allocated: 82462010077184
 referenced 9374576852992

How to fix it? Can "btrfs-check --repair --init-extent-tree" help?
P.S. I ran all the commands from Fedora 26 Alpha Live disk with kernel
4.11.0-0.rc3.git0.2.fc26.x86_64 and btrfs-progs v.4.9.1

--
Ivan Sizov
