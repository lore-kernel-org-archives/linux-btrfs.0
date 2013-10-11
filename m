Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:36329 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789Ab3JKRUR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 13:20:17 -0400
Received: by mail-bk0-f41.google.com with SMTP id na10so1742387bkb.28
        for <linux-btrfs@vger.kernel.org>; Fri, 11 Oct 2013 10:20:16 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <20131011114229.GE5787@twin.jikos.cz>
References: <1381092807-21422-1-git-send-email-fdmanana@gmail.com>
	<1381094553-2190-1-git-send-email-fdmanana@gmail.com>
	<20131011114229.GE5787@twin.jikos.cz>
Date: Fri, 11 Oct 2013 18:20:16 +0100
Message-ID: <CAL3q7H6o3auNremGh8X0oFF_OcVuwpSxsOrAKDBmtx+d4eLxAQ@mail.gmail.com>
Subject: Re: [PATCH v2] Btrfs: improve inode hash function/inode lookup
From: Filipe David Manana <fdmanana@gmail.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Filipe David Borba Manana <fdmanana@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 11, 2013 at 12:42 PM, David Sterba <dsterba@suse.cz> wrote:
> On Sun, Oct 06, 2013 at 10:22:33PM +0100, Filipe David Borba Manana wrote:
>> 2) On 32 bits machines. Th VFS hash values are unsigned longs, which
>>    are 32 bits wide on 32 bits machines, and the inode (objectid)
>>    numbers are 64 bits unsigned integers. We simply cast the inode
>>    numbers to hash values, which means that for all inodes with the
>>    same 32 bits lower half, the same hash bucket is used for all of
>>    them. For example, all inodes with a number (objectid) between
>>    0x0000_0000_ffff_ffff and 0xffff_ffff_ffff_ffff will end up in
>>    the same hash table bucket.
>
> Well, inode number that does not fit into 32 bits on a 32 bit machine
> causes other problems. And subvolume ids that do not fit into 32 bits
> cannot be stored in radix tree.
>
> It would be safer to refuse creating/accessing inode/subvolume with
> nubmer that does not fit into 32bits.

Good point David. However it would be a rather radical behaviour change imho.
I think it should be a separate change if there are no objections
against such change.

>
> david



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
