Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:34032 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbcFYQZi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 25 Jun 2016 12:25:38 -0400
Received: by mail-oi0-f43.google.com with SMTP id s66so152694153oif.1
        for <linux-btrfs@vger.kernel.org>; Sat, 25 Jun 2016 09:25:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c87e2f76-6cd6-46a4-21ca-dc5f66898d59@crc.id.au>
References: <15415597-7f29-396e-8425-8cbbeb32e897@crc.id.au>
 <4e1bff4c-3cfc-4391-d093-8293bf29e795@crc.id.au> <CAN05THTxMBrP-JV7atjdskfDYybwmEAV61EDkWRW_Yk70Cfdjg@mail.gmail.com>
 <dd7fd123-c3a2-7ad0-bf22-a67a1b1a97d7@crc.id.au> <d00790ae-bf8d-ee18-06a9-d0c5f6010129@gmail.com>
 <47f587fd-b553-5ed7-ac38-202bf7297350@crc.id.au> <f0fb8364-de4b-e85f-a8ff-87892c1e3a79@gmail.com>
 <c87e2f76-6cd6-46a4-21ca-dc5f66898d59@crc.id.au>
From: Chris Murphy <lists@colorremedies.com>
Date: Sat, 25 Jun 2016 10:25:37 -0600
Message-ID: <CAJCQCtRrF-KZOo3HOzNWHwhWcDxFem-tcpGh5ScXoQM2Brosag@mail.gmail.com>
Subject: Re: Trying to rescue my data :(
To: Steven Haigh <netwiz@crc.id.au>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 24, 2016 at 10:19 PM, Steven Haigh <netwiz@crc.id.au> wrote:

>
> Interesting though that EVERY crash references:
>         kernel BUG at fs/btrfs/extent_io.c:2401!

Yeah because you're mounted ro, and if this is 4.4.13 unmodified btrfs
from kernel.org then that's the 3rd line:

if (head->is_data) {
    ret = btrfs_del_csums(trans, root,
       node->bytenr,
       node->num_bytes);

So why/what is it cleaning up if it's mounted ro? Anyway, once you're
no longer making forward progress you could try something newer,
although it's a coin toss what to try. There are some issues with
4.6.0-4.6.2 but there have been a lot of changes in btrfs/extent_io.c
and btrfs/raid56.c between 4.4.13 that you're using and 4.6.2, so you
could try that or even build 4.7.rc4 or rc5 by tomorrowish and see how
that fairs. It sounds like there's just too much (mostly metadata)
corruption for the degraded state to deal with so it may not matter.
I'm really skeptical of btrfsck on degraded fs's so I don't think
that'll help.


-- 
Chris Murphy
