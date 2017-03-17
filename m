Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:55630 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751019AbdCQIna (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 04:43:30 -0400
Subject: Re: help : "bad tree block start" -> btrfs forced readonly
To: Lionel Bouton <lionel-subscription@bouton.name>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <0ec911af-2932-72df-d9b3-bd27616e101e@bouton.name>
 <c704f24e-4ea2-43fe-909e-92ad98bf6d28@bouton.name>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <4866fa5d-d9bc-653a-17d8-b555fc55491e@mendix.com>
Date: Fri, 17 Mar 2017 09:43:27 +0100
MIME-Version: 1.0
In-Reply-To: <c704f24e-4ea2-43fe-909e-92ad98bf6d28@bouton.name>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/17/2017 09:11 AM, Lionel Bouton wrote:
> Le 17/03/2017 à 05:32, Lionel Bouton a écrit :
>> Hi,
>>
>> [...]
>> I'll catch some sleep right now (it's 5:28 AM here) but I'll be able to
>> work on this in 3 or 4 hours.
> 
> I woke up to this :
> 
> Mar 17 06:56:30 fileserver kernel: btree_readpage_end_io_hook: 104476
> callbacks suppressed
> Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
> block start 72340172838076673 3415463870464
> Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
> block start 72340172838076673 3415463870464
> Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
> block start 72340172838076673 3415463870464
> Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
> block start 72340172838076673 3415463870464
> Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
> block start 72340172838076673 3415463870464
> Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
> block start 72340172838076673 3415463870464
> Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
> block start 72340172838076673 3415463870464
> Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
> block start 72340172838076673 3415463870464
> Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
> block start 72340172838076673 3415463870464
> Mar 17 06:56:30 fileserver kernel: BTRFS error (device sdb): bad tree
> block start 72340172838076673 3415463870464

The error is about a page of metadata (tree block) that is damaged or
has been lost.

Your btrfs is reading the metadata page at location 3415463870464
(virtual address space). Inside the page, the address is stored again as
a method of verification.

The error means that it expected to see metadata items that live in a
block at position 3415463870464 in your filesystem virtual address
space, but instead it encounters some data, from which the bytes in the
location where that address should be translate back to 72340172838076673.

I needed to look at the kernel source code to figure this out, the error
is not very descriptive.

found_start = btrfs_header_bytenr(eb);
if (found_start != eb->start) {
    btrfs_err_rl(fs_info, "bad tree block start %llu %llu",
        found_start, eb->start);
    ret = -EIO;
    goto err;
}

> and the server was unusable.

The impact depends heavily on what part of the metadata it is, which
tree it's from, how much tree is hidden behind it etc.

You can try btrfs-debug-tree -b 3415463870464 <blockdevice> to see if it
outputs any readable information. If this was a metadata page, it would
have at least a corrupted bytenr field, otherwise it's likely not
something in the btrfs metadata format.

> I just moved the client to a read-only backup server and we are trying
> to find out if we can salvage this or if we start the full restore
> procedure.

-- 
Hans van Kranenburg
