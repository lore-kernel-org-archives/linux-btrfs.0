Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f51.google.com ([209.85.214.51]:60888 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab3H3PKL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Aug 2013 11:10:11 -0400
Received: by mail-bk0-f51.google.com with SMTP id mx10so705374bkb.24
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Aug 2013 08:10:10 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20130830145903.GL23113@twin.jikos.cz>
References: <1377780253-17826-1-git-send-email-fdmanana@gmail.com>
	<1377804111-15247-1-git-send-email-fdmanana@gmail.com>
	<20130830141435.GK23113@twin.jikos.cz>
	<CAL3q7H4s4OrCkgws8Q4qZXezk-_WGGucc3C84Ud3Xy5d0zFgKQ@mail.gmail.com>
	<20130830145903.GL23113@twin.jikos.cz>
Date: Fri, 30 Aug 2013 16:10:10 +0100
Message-ID: <CAL3q7H7iOS_VSij1sidFrLzqLXK43vTJB1HWz3eKGDKAX094wA@mail.gmail.com>
Subject: Re: [PATCH v4] Btrfs: optimize key searches in btrfs_search_slot
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 30, 2013 at 3:59 PM, David Sterba <dsterba@suse.cz> wrote:
> On Fri, Aug 30, 2013 at 03:47:21PM +0100, Filipe David Manana wrote:
>> Sure.
>> They're actually better now :)
>
> Thanks. The numbers changed in both samples, but the relative difference
> is still 2x improvement in this particular test.

I tend to favor the percentiles above everything else, and for these
last comparison, they're all about 5x better. These times are for a
single search node/leaf. The highest the level (where root is highest)
an exact match first happens, the better it will be for the overall
tree search operation, as more times this optimal code path will be
executed.

>
> david



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
