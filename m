Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:35546 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752962AbdDCOom (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Apr 2017 10:44:42 -0400
Subject: Re: Need some help: "BTRFS critical (device sda): corrupt leaf, slot
 offset bad: block"
To: Robert Krig <robert.krig@render-wahnsinn.de>, linux-btrfs@vger.kernel.org
References: <635a5ca8-9fa5-6cd4-21b5-97f9f3db93d3@render-wahnsinn.de>
 <c304c651-88fc-4699-3518-c4e83095d9c0@mendix.com>
 <98a478cf-20f9-981f-6da5-4186a10be303@render-wahnsinn.de>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <b863d020-8d6c-f0af-5c62-b84bb752bd59@mendix.com>
Date: Mon, 3 Apr 2017 16:44:30 +0200
MIME-Version: 1.0
In-Reply-To: <98a478cf-20f9-981f-6da5-4186a10be303@render-wahnsinn.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/03/2017 04:20 PM, Robert Krig wrote:
> 
> 
> On 03.04.2017 16:08, Hans van Kranenburg wrote:
>> On 04/03/2017 12:11 PM, Robert Krig wrote:
>> The corruption is at item 157. Can you attach all of the output, or
>> pastebin it?
>>
> 
> I've attached the entire log of btrfs-debug-tree. This was generated
> with btrfs-progs 4.7.3

Meuh,

item 156 key (23416298414080 EXTENT_ITEM 4096) itemoff 8643 itemsize 53
item 157 key (23416298418176 EXTENT_ITEM 4096) itemoff 8590 itemsize 53

8590 + 53 = 8643.

I don't get what's invalid about that.

"incorrect offsets 8590 1258314415"

if (btrfs_item_offset_nr(buf, i) !=
    btrfs_item_end_nr(buf, i + 1)) {
    ret = BTRFS_TREE_BLOCK_INVALID_OFFSETS;
    fprintf(stderr, "incorrect offsets %u %u\n",
        btrfs_item_offset_nr(buf, i),
        btrfs_item_end_nr(buf, i + 1));
    goto fail;
}

Ah, ok, so the corruption is in item 158, but it's reported as
corruption in item 157.

There's no really simple tool right now to fix this manually. We can
also try to dd 16kiB of metadata from disk, fix it, and write it back.
We've been doing that before, it's a bit of work, but it can succeed.
Here's more instructions:

https://www.spinics.net/lists/linux-btrfs/msg62459.html

So, if you're the adventurous type...

But then again, if this is really memory failure, there might be other
errors all around the fs, which you didn't hit while reading back the
data yet.

Also note that btrfs does not protect you against this, also not for
data in files that gets corrupted in memory before it's written out
(which contains the checksum step).

> If it makes a difference, I can try it again with the newest version of
> btrfs-progs?

No, that code hasn't been touched in over 5 years.

-- 
Hans van Kranenburg
