From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Still ENOSPC problems with 2.6.35-rc3
Date: Thu, 17 Jun 2010 08:47:07 +0800
Message-ID: <AANLkTikL6C9Ize1K-Hixsb9PEePezAQDR7FbQ7EemiRX@mail.gmail.com>
References: <201006161948.26611.johannes.hirte@fem.tu-ilmenau.de>
	<AANLkTinQPUYU3tMWdPvJiM5aGNDBxW2zkr9TVWezuuar@mail.gmail.com>
	<201006170156.54551.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201006170156.54551.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 17, 2010 at 7:56 AM, Johannes Hirte
<johannes.hirte@fem.tu-ilmenau.de> wrote:
> Am Donnerstag 17 Juni 2010, 01:12:54 schrieb Yan, Zheng:
>> On Thu, Jun 17, 2010 at 1:48 AM, Johannes Hirte
>>
>> <johannes.hirte@fem.tu-ilmenau.de> wrote:
>> > With kernel-2.6.34 I run into the ENOSPC problems that where reported on
>> > this list recently. The filesystem was somewhat over 90% full and most
>> > operations on it caused a Oops. I was able to delete files by trial and
>> > error and freed up half of the filesystem space. Operation on the other
>> > files still caused an Oops.
>> >
>> > For 2.6.35 there went some patches in, that addressed this problem. Sadly
>> > they don't fix it but only avoid the Oops. A simple 'ls' on this
>> > filesystem results in
>>
>> To avoid ENOSPC oops, btrfs in 2.6.35 reserves more metadata space for
>> system use than older btrfs. If the FS has already ran out of metadata
>> space, using btrfs in 2.6.35 doesn't help.
>>
>> Yan, Zheng
>
> So how can this be fixed/avoided? There must be some free metadata space, since
> I was able to delete files, more than 20Gig, mostly small files. Also from my
> understanding, when freeing space by deleting files, metadata space should be
> freed. Or do I get something wrong here?
> 2.6.35 does change something, since I can delete more files, where 2.6.34 does
> Oops. But you're right, it doesn't help at all. So, where is this space and
> why it can't be used?
>

what will happen if you keep deleting files using 2.6.35?

Yan, Zheng
