Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:57234 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750933AbcHYTju (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 15:39:50 -0400
Subject: Re: [BUG] kernel BUG at fs/btrfs/extent_io.c:2062 (v4.2.0-rc8)
To: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAOE4rSwPNAY7fXjVa=Hyeb1yVMtVmpPhUvMVbZt6Qq9P+a0LCA@mail.gmail.com>
 <CAOE4rSxn756hHWJB9T32__dbRNeF0aQOCvCe1738G_HHqy3+Xw@mail.gmail.com>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <bd6d731e-583c-b5f7-d95f-3ad70242297a@mendix.com>
Date: Thu, 25 Aug 2016 19:45:11 +0200
MIME-Version: 1.0
In-Reply-To: <CAOE4rSxn756hHWJB9T32__dbRNeF0aQOCvCe1738G_HHqy3+Xw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/25/2016 07:26 PM, Dāvis Mosāns wrote:
> 2015-08-31 9:28 GMT+03:00 Dāvis Mosāns <davispuh@gmail.com>:
>> I'm getting kernel crash and complete system lockup when trying to access
>> journal on two disk btrfs filesystem with data/metadata as RAID1.
> 
> I kept those drives untouched and now I tried again with Linux 4.7.1
> and accessing that file it didn't crashed but shows Input/output error

I don't see "Input/output error" anywhere in the messages?

> $ btrfs check --repair --check-data-csum  /dev/vda
> enabling repair mode
> Checking filesystem on /dev/vda
> UUID: 247e6249-6de1-45cb-9dd0-fa8a654234bf
> checking extents
> Incorrect local backref count on 99753574400 root 261 owner 523015
> offset 4063232 found 2 wanted 4 back 0xf1bd3c0
> Incorrect global backref count on 99753574400 found 2 wanted 4
> backpointer mismatch on [99753574400 8192]
> repair deleting extent record: key 99753574400 168 8192
> adding new data backref on 99753574400 root 261 owner 523015 offset
> 4063232 found 2
> [...]

These messages might be unrelated. Also see this email thread from
yesterday, reporting the same, for more info:

btrfs-progs 4.7, check reports many "incorrect local backref count" messages

-- 
Hans van Kranenburg - System / Network Engineer
T +31 (0)10 2760434 | hans.van.kranenburg@mendix.com | www.mendix.com
