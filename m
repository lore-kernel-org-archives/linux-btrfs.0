Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f42.google.com ([209.85.214.42]:49889 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754580Ab3IBOkl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 2 Sep 2013 10:40:41 -0400
Received: by mail-bk0-f42.google.com with SMTP id my10so1697412bkb.1
        for <linux-btrfs@vger.kernel.org>; Mon, 02 Sep 2013 07:40:40 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130902133909.GX23113@twin.jikos.cz>
References: <1377780253-17826-1-git-send-email-fdmanana@gmail.com>
	<1378031968-22062-1-git-send-email-fdmanana@gmail.com>
	<20130902133909.GX23113@twin.jikos.cz>
Date: Mon, 2 Sep 2013 15:40:39 +0100
Message-ID: <CAL3q7H4YjTeTBj2DoVP1wQXQiCqnMrbXUqFFOKuDR-rRNW+zXA@mail.gmail.com>
Subject: Re: [PATCH v7] Btrfs: optimize key searches in btrfs_search_slot
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 2, 2013 at 2:39 PM, David Sterba <dsterba@suse.cz> wrote:
> On Sun, Sep 01, 2013 at 11:39:28AM +0100, Filipe David Borba Manana wrote:
>> +#ifdef CONFIG_BTRFS_ASSERT
>> +static int key_search_validate(struct extent_buffer *b,
>> +                            struct btrfs_key *key,
>> +                            int level)
>> +{
> ...
>> +}
>> +#endif
>> +
>> +static int key_search(struct extent_buffer *b, struct btrfs_key *key,
>> +                   int level, int *prev_cmp, int *slot)
>> +{
>> +     if (*prev_cmp != 0) {
>> +             *prev_cmp = bin_search(b, key, level, slot);
>> +             return *prev_cmp;
>> +     }
>> +
>> +     ASSERT(key_search_validate(b, key, level));
>
> But what if I want to use key_search_validate out of the context of an
> ASSERT ?

Right. But right now nothing else uses it. Shall the need for it come,
it's trivial to address.

> I don't see a reason why the function needs to be under #ifdef
> BTRFS_ASSERT / #endif at all.

To avoid the compiler warning, as mentioned before.

Between patch versions v5 to v7, I don't have any strong preference.
All have correct, small and simple code.

>
>> +     *slot = 0;
>> +
>> +     return 0;
>> +}



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
