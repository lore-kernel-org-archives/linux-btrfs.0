Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oa0-f45.google.com ([209.85.219.45]:53645 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab3B0UKZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 15:10:25 -0500
MIME-Version: 1.0
In-Reply-To: <20130227182617.GI19641@localhost.localdomain>
References: <20130227052247.GA20213@redhat.com>
	<20130227132736.GH19641@localhost.localdomain>
	<CAFDW0jK6zigx0YgVMHomUkRQkqpw5mUgkdeynv36LUiQn4XTxg@mail.gmail.com>
	<20130227182617.GI19641@localhost.localdomain>
Date: Wed, 27 Feb 2013 21:10:25 +0100
Message-ID: <CAFDW0jJ2yHftRW5Kp8sc+uxNC3oS4AZKqG0Szz2rUyxeeA0+2Q@mail.gmail.com>
Subject: Re: btrfs crash when low on memory.
From: Ahmet Inan <ainan@mathematik.uni-freiburg.de>
To: Josef Bacik <jbacik@fusionio.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 27, 2013 at 7:26 PM, Josef Bacik <jbacik@fusionio.com> wrote:
> On Wed, Feb 27, 2013 at 07:31:11AM -0700, Ahmet Inan wrote:
>> > Yeah we have a lot of
>> >
>> > ptr = kmalloc();
>> > BUG_ON(ptr);
>> >
>> > everywhere.  I'll fix this one up but I really need to sit down and go through
>> > all of them and make sure we do the right thing in all these places.  Thanks,
>>
>> But what would be the right thing to do when you got no memory?
>> Spinlock until you can kmalloc? Pre-reserve some memory?
>>
>
> Return ENOMEM?  We have a way to abort transactions now, if it's in a horrible
> of enough spot we can just abort the transaction and let the user deal with the
> aftermath, it's nicer than panicing.  Thanks,

youre right. i am only afraid of silent corruption of data on aborts:
our guys here trigger OOM all the time with their compilers and
numerical codes (go figure).
and until now we had no more aborts / panics because of
"vm.min_free_kbytes = 65536" and thus no corruption.

my point is:
i like a freezing computer more than an corrupting computer, even if
its a server. reboot to the rescue.

Ahmet
