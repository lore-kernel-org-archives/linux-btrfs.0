Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.render-wahnsinn.de ([188.40.36.198]:59036 "EHLO
        mail.render-wahnsinn.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752048AbdDCOZE (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Apr 2017 10:25:04 -0400
Subject: Re: Need some help: "BTRFS critical (device sda): corrupt leaf, slot
 offset bad: block"
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <635a5ca8-9fa5-6cd4-21b5-97f9f3db93d3@render-wahnsinn.de>
 <c304c651-88fc-4699-3518-c4e83095d9c0@mendix.com>
 <98a478cf-20f9-981f-6da5-4186a10be303@render-wahnsinn.de>
From: Robert Krig <robert.krig@render-wahnsinn.de>
Message-ID: <7f94b6b9-f18d-14dd-4a20-1793ce08df8a@render-wahnsinn.de>
Date: Mon, 3 Apr 2017 16:25:00 +0200
MIME-Version: 1.0
In-Reply-To: <98a478cf-20f9-981f-6da5-4186a10be303@render-wahnsinn.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 03.04.2017 16:20, Robert Krig wrote:
>
> On 03.04.2017 16:08, Hans van Kranenburg wrote:
>> On 04/03/2017 12:11 PM, Robert Krig wrote:
>> The corruption is at item 157. Can you attach all of the output, or
>> pastebin it?
>>
>
> I've attached the entire log of btrfs-debug-tree. This was generated
> with btrfs-progs 4.7.3
>
> If it makes a difference, I can try it again with the newest version of
> btrfs-progs?


I forgot to mention that btrfs-debug-tree also segfaults with a "memory
access error"

I'm gonna run a extensive memory check once I get home, since you
mentioned corrupt memory might be an issue here.
