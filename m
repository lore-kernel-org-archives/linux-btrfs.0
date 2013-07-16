Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f171.google.com ([209.85.128.171]:38389 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab3GPPKD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 16 Jul 2013 11:10:03 -0400
Received: by mail-ve0-f171.google.com with SMTP id b10so591986vea.16
        for <linux-btrfs@vger.kernel.org>; Tue, 16 Jul 2013 08:10:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51E549C6.1090303@giantdisaster.de>
References: <CABF9=8i1Bd6mVOR8kNZmQJa2UJLg9tiCojWHbN1HLVWhEh7_0g@mail.gmail.com>
	<20130716113745.GI24343@twin.jikos.cz>
	<51E549C6.1090303@giantdisaster.de>
Date: Tue, 16 Jul 2013 11:10:01 -0400
Message-ID: <CABF9=8icR2PqbenvZws6epgF7yaKfu-t93mHvOoMAxt=dzDVTw@mail.gmail.com>
Subject: Re: filebench varmail + scrubber = btrfs_update_root bug
From: George Amvrosiadis <gamvrosi@gmail.com>
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

FYI, updating to 3.10 seems to have solved the problem (after some
rigorous testing, I haven't been able to trigger the BUG again).

> > item 0 key (18446744073709551606 80 6597246976)
> Is (objectid = -10 = BTRFS_EXTENT_CSUM_OBJECTID, type = 0x80 =
> BTRFS_EXTENT_CSUM_KEY)
>
>
> > unable to update root key 18446744073709551610 132 5
> Is (objectid = -6 = BTRFS_TREE_LOG_OBJECTID, type = 132 =
> BTRFS_ROOT_ITEM_KEY, offset = 5)
>

Stefan, thanks for clarifying that 18446744073709551606 is a valid
objectid. I somehow failed to notice those definitions in ctree.h

-- George

--
George Amvrosiadis, B.Sc., Ph.D. Student
Graduate Students' Union Representative
Computer Science, University of Toronto
