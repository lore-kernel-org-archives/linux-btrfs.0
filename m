Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36621 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754173AbcHAQeq (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 12:34:46 -0400
Received: by mail-oi0-f46.google.com with SMTP id w18so200040332oiw.3
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Aug 2016 09:34:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <dac1d283-feb1-f496-0637-8ba57398d055@fb.com>
References: <CAJCQCtQOV4gsh-Kaz6n=d9KBYCyOh9eb65-G8KBd8B_HJ_tNBg@mail.gmail.com>
 <CAJCQCtQYicoze=jBf9ptQABLZSxgd67MYUbCs2igB2PipugxaA@mail.gmail.com> <dac1d283-feb1-f496-0637-8ba57398d055@fb.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 1 Aug 2016 10:34:39 -0600
Message-ID: <CAJCQCtQ4+vk=1WKDBcZ8vHSHhZgDeymhMc5F_Bc7xaNx8oMGEQ@mail.gmail.com>
Subject: Re: qcow2 becomes 37P in size while qemu crashes
To: Chris Mason <clm@fb.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 1, 2016 at 9:26 AM, Chris Mason <clm@fb.com> wrote:
>
>
> On 07/23/2016 04:05 PM, Chris Murphy wrote:
>>
>> Using btrfs-debug-tree, I'm finding something a bit odd about some of
>> the items in this 39P file.
>>
>> Seems normal
>>
>>     item 71 key (994163 EXTENT_DATA 43689967616) itemoff 12467 itemsize 53
>>         extent data disk byte 617349906432 nr 80805888
>>         extent data offset 0 nr 80805888 ram 80805888
>>         extent compression(none)
>>
>> Seems not normal
>>
>>     item 58 key (994163 EXTENT_DATA 38345535488) itemoff 13156 itemsize 53
>>         extent data disk byte 0 nr 0
>>         extent data offset 394752000 nr 61440 ram 34626881742770176
>>         extent compression(none)
>>
>> There are quite a large number of items that take the 2nd form, and in
>> each case the ram value is the same as above.
>>
>>
>
> Can't really blame a bit flip for that one.  Looks like our hole truncation
> math has gone crazy there.  I'll see what I can find, but please yell if you
> can reproduce.

I've been trying, but no joy. Several bugs are required before hitting this.

User bug: I inadvertently edited the machine using virsh to use the
same backing qcow2 file for vda and vdb.
virsh bug: No warning for this double usage.
virt-manager bug: Starts the VM without warning when two virtio
devices are pointed to the same backing file.

Corruption of the file is inevitable. But exactly when it grew to 37P
I'm not sure, so far reproducing this results in a file limited to the
create time specified file size.


-- 
Chris Murphy
