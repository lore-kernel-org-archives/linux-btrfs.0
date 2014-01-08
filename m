Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:42060 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbaAHVBL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Jan 2014 16:01:11 -0500
MIME-Version: 1.0
In-Reply-To: <1389214325.23310.34.camel@ret.masoncoding.com>
References: <20140102053101.GA29352@localhost>
	<CAFR8uee-WTy6cj8bB4aMuGP1B0sZkc70sq1Drg7uhHS49EqHcg@mail.gmail.com>
	<20140106221036.GE9037@kmo>
	<CAFR8uef3XUEsHUvfnkAbzsXict8qD_28fTgUQyA7gjUk03OUsw@mail.gmail.com>
	<20140107055318.GA19016@localhost>
	<CAFR8ueeC_fqpN+M5YOr8AT_o3BDgr+o1ELQQJQSW7s8uDm2y5Q@mail.gmail.com>
	<1389126617.23310.19.camel@ret.masoncoding.com>
	<CAFR8ueezG4U5ULcp0ayhY690RUE7280UL68d55+tGCqDW9A1Kg@mail.gmail.com>
	<1389210102.23310.31.camel@ret.masoncoding.com>
	<CAFR8uefXjN_nzHWsTF=-PxNPDMWMj5Hw+ueFYQwa8-qBEGMGTw@mail.gmail.com>
	<1389212231.23310.33.camel@ret.masoncoding.com>
	<CAFR8uec00zThzs5Q21ySG90shQHVxbRZDGrYBPrdn1KbNCQ_vw@mail.gmail.com>
	<1389214325.23310.34.camel@ret.masoncoding.com>
Date: Wed, 8 Jan 2014 13:01:10 -0800
Message-ID: <CAFR8uefj7=x149nAQOwX5pw-5OCXnS6oYYF8xZkQVrdmPJBD6g@mail.gmail.com>
Subject: Re: [block:for-3.14/core] kernel BUG at fs/bio.c:1748
From: Muthu Kumar <muthu.lkml@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: "kmo@daterainc.com" <kmo@daterainc.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lkp@linux.intel.com" <lkp@linux.intel.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 8, 2014 at 12:51 PM, Chris Mason <clm@fb.com> wrote:
> On Wed, 2014-01-08 at 12:40 -0800, Muthu Kumar wrote:
>> On Wed, Jan 8, 2014 at 12:16 PM, Chris Mason <clm@fb.com> wrote:
>> > On Wed, 2014-01-08 at 11:54 -0800, Muthu Kumar wrote:
>> >> Chris,
>> >>
>> >> [    8.336061] WARNING: CPU: 0 PID: 0 at fs/bio.c:1778 bio_endio+0xbe/0x100()
>> >> [    8.336062] bio_endio: bio for (unknown) without endio
>> >>
>> >> This is my recent change to avoid memory leak in bio_endio. But I
>> >> think the problem is higher up, most likely bio_endio is called twice
>> >> on the same bio (which was freed before).
>> >>
>> >
>> > I think these are just two separate problems.  Lets ignore the WARN_ON
>> > for now.
>> >
>>
>> Not really... the BUG that is triggered:
>>
>> kernel BUG at fs/bio.c:523!
>>
>> It is in bio_put() (added to bio_endio() as part of recent change)
>> which gets an already freed bio.
>>
>
> Oh! I see.  Let me try with that one reverted.  Thanks!
>
> -chris
>

But, like I said, problem is in different place. I am running a "dd"
on ext4 fs for a while now, but didn't hit the problem. Any idea to
repro locally? I would also suggest running just the for-3.1/core to
isolate the issue.
