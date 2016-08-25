Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f47.google.com ([209.85.214.47]:37296 "EHLO
        mail-it0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754797AbcHYSy7 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 25 Aug 2016 14:54:59 -0400
Received: by mail-it0-f47.google.com with SMTP id f6so106211831ith.0
        for <linux-btrfs@vger.kernel.org>; Thu, 25 Aug 2016 11:54:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <bd6d731e-583c-b5f7-d95f-3ad70242297a@mendix.com>
References: <CAOE4rSwPNAY7fXjVa=Hyeb1yVMtVmpPhUvMVbZt6Qq9P+a0LCA@mail.gmail.com>
 <CAOE4rSxn756hHWJB9T32__dbRNeF0aQOCvCe1738G_HHqy3+Xw@mail.gmail.com> <bd6d731e-583c-b5f7-d95f-3ad70242297a@mendix.com>
From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Date: Thu, 25 Aug 2016 21:54:37 +0300
Message-ID: <CAOE4rSyGW3TUG75_iRuBRJ-Ekmrmwt_BhOoXgRDNvgEL62M53g@mail.gmail.com>
Subject: Re: [BUG] kernel BUG at fs/btrfs/extent_io.c:2062 (v4.2.0-rc8)
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

2016-08-25 20:45 GMT+03:00 Hans van Kranenburg <hans.van.kranenburg@mendix.com>:
> On 08/25/2016 07:26 PM, Dāvis Mosāns wrote:
>> 2015-08-31 9:28 GMT+03:00 Dāvis Mosāns <davispuh@gmail.com>:
>>> I'm getting kernel crash and complete system lockup when trying to access
>>> journal on two disk btrfs filesystem with data/metadata as RAID1.
>>
>> I kept those drives untouched and now I tried again with Linux 4.7.1
>> and accessing that file it didn't crashed but shows Input/output error
>
> I don't see "Input/output error" anywhere in the messages?
>

I didn't included it here, it's very simple, any access to that file shows it

$ cat system@00051e80d8810e86-e5a1ec29d9167e9f.journal~
cat: system@00051e80d8810e86-e5a1ec29d9167e9f.journal~: Input/output error

even if scrub completed successfully without any errors.

also I just noticed this thread
"btrfs partition fails to mount - kernel BUG at ../fs/btrfs/extent-tree.c:1872"
it's this same crash I'm hinting here with balance.

kernel: kernel BUG at fs/btrfs/extent-tree.c:1872!
