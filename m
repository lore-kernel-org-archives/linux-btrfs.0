Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:52546 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451AbaJ1KJi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 28 Oct 2014 06:09:38 -0400
Received: by mail-lb0-f182.google.com with SMTP id f15so313182lbj.13
        for <linux-btrfs@vger.kernel.org>; Tue, 28 Oct 2014 03:09:36 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20141027183338.GL18164@carfax.org.uk>
References: <alpine.DEB.2.19.4.1410270333250.9302@trent.utfs.org>
	<CAL3q7H4MbLCVXxLzT5d4vim1pp8ffZRsLX2GwDqgXNK3p5+sLg@mail.gmail.com>
	<20141027153532.GF22943@twin.jikos.cz>
	<alpine.DEB.2.19.4.1410271117030.9302@trent.utfs.org>
	<20141027183338.GL18164@carfax.org.uk>
Date: Tue, 28 Oct 2014 10:09:36 +0000
Message-ID: <CAL3q7H6SrMDUi4vdH7EyBL863LTfV-3XnH33Jmbn-+mNxapXkQ@mail.gmail.com>
Subject: Re: suspicious number of devices: 72057594037927936
From: Filipe David Manana <fdmanana@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Christian Kujau <lists@nerdbynature.de>,
        David Sterba <dsterba@suse.cz>,
        Filipe David Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 27, 2014 at 6:33 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Mon, Oct 27, 2014 at 11:21:13AM -0700, Christian Kujau wrote:
>> On Mon, 27 Oct 2014 at 16:35, David Sterba wrote:
>> > Yeah sorry, I sent the v2 too late, here's an incremental that applies
>> > on top of current 3.18-rc
>> >
>> > https://patchwork.kernel.org/patch/5160651/
>>
>> Yup, that fixes it. Thank you! If it's needed:
>>
>>   Tested-by: Christian Kujau <lists@nerdbynature.de>
>>
>> @Filipe: and thanks for warning me about 3.17 - I used 3.17.0 since it
>> came out and compiled kernels on the btrfs partition and haven't had any
>> issues. But it wasn't used very often, so whatever the serious issues
>> were, I haven't experienced any.
>
>    If you make read-only snapshots, there's a good chance of metadata
> corruption. It's fixed in 3.17.2.

Well not only because of that issue, but also because of file extent
map corruption, which manifests itself in several different ways, such
as EEXIST errors on file write [1] or fiemap [2] calls for example,
and likely file metadata corruption after fsync + log recovery.
This is fixed in 3.17.2 too.

[1] http://www.spinics.net/lists/linux-btrfs/msg37567.html
[2] http://www.spinics.net/lists/linux-btrfs/msg38045.html

>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>    --- Our so-called leaders speak/with words they try to jail ya/ ---
>         They subjugate the meek/but it's the rhetoric of failure.
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
