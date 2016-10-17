Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35890 "EHLO
        mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754005AbcJQDqX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 16 Oct 2016 23:46:23 -0400
Received: by mail-lf0-f54.google.com with SMTP id b75so265248332lfg.3
        for <linux-btrfs@vger.kernel.org>; Sun, 16 Oct 2016 20:46:22 -0700 (PDT)
Subject: Re: Copy BTRFS volume to another BTRFS volume including subvolumes
 and snapshots
To: Alberto Bursi <alberto.bursi@outlook.it>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <AM3PR08MB06423820D86D1E408FFD766492DC0@AM3PR08MB0642.eurprd08.prod.outlook.com>
 <905eb030-f8d8-b7cc-dd27-2f55e0d812c5@gmail.com>
 <AM3PR08MB06421C9E387257BB6945837C92DF0@AM3PR08MB0642.eurprd08.prod.outlook.com>
 <CAJCQCtTnoHrY3ZwkDY1HN6wavfduFKxKa94F6iVQtaKtR2aJ-w@mail.gmail.com>
 <AM3PR08MB0642BADAFC2420A8F54C670392DF0@AM3PR08MB0642.eurprd08.prod.outlook.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <6edc873e-57eb-41bd-3643-fc8cd4155a36@gmail.com>
Date: Mon, 17 Oct 2016 06:46:20 +0300
MIME-Version: 1.0
In-Reply-To: <AM3PR08MB0642BADAFC2420A8F54C670392DF0@AM3PR08MB0642.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

15.10.2016 01:58, Alberto Bursi пишет:
> 
> 
> On 10/15/2016 12:17 AM, Chris Murphy wrote:
>> It should be -e can accept a listing of all the subvolumes you want to
>> send at once. And possibly an -r flag, if it existed, could
>> automatically populate -e. But the last time I tested -e I just got
>> errors.
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=111221
>>
>>
> 
> Not a problem (for me anyway), I can send all subvolumes already with my 
> script (one after another, but still automatically).
> 
> What I can't do with btrfs commands is to send over the contents of a ro 
> snapshot of / called for example "oldRootSnapshot", directly to 
> "/tmp/newroot" (which is where I have mounted the other drive/volume).
> 

Somehow this is expected - it sends one subvolume to another subvolume.
I am not sure whether zfs can do it either.

But speaking about openSUSE - it does not have any real data in `/' at
all - it is just skeleton of root filesystem with a couple of
directories where actual root is in one of /.snapshots subvolumes.

> The only thing I can do is send over the subvolume as a subvolume.
> So I end up with /tmp/newroot/oldRootSnapshot and inside oldRootSnapshot 
> I get my root, not what I wanted.
> 
> Only way I found so far is using rsync to move the contents of 
> oldRootSnapshot in the /tmp/newroot by setting an exclusion list for all 
> subvolumes, then run a deduplication with duperemove.
> 
> So, is there something I missed to do that?
> 
> -Alberto
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{�n�߲)���w*jg��������ݢj/���z�ޖ��2�ޙ���&�)ߡ�a�����G���h��j:+v���w�٥
> 

