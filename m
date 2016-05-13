Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33161 "EHLO
	mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbcEMVfg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 May 2016 17:35:36 -0400
Received: by mail-oi0-f66.google.com with SMTP id t140so6583558oie.0
        for <linux-btrfs@vger.kernel.org>; Fri, 13 May 2016 14:35:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87vb2ij7u5.fsf@vostro.rath.org>
References: <87y47g1esh.fsf@thinkpad.rath.org>
	<CAPmG0jYDw8Sid2jORVtfwNLpeZPAqtH429EQsraz9GzNdK1aUQ@mail.gmail.com>
	<pan$14f07$a448b38$b8e37f4a$116d54ce@cox.net>
	<87vb2ij7u5.fsf@vostro.rath.org>
Date: Fri, 13 May 2016 15:35:35 -0600
Message-ID: <CAJCQCtRs6VhRDFT6PvD4LkKYvtMero7UBs6Gd-XtjHLqwBe-5Q@mail.gmail.com>
Subject: Re: fsck: to repair or not to repair
From: Chris Murphy <lists@colorremedies.com>
To: Nikolaus Rath <Nikolaus@rath.org>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 13, 2016 at 9:28 AM, Nikolaus Rath <Nikolaus@rath.org> wrote:
> On May 13 2016, Duncan <1i5t5.duncan@cox.net> wrote:
>> Because btrfs can be multi-device, it needs some way to track which
>> devices belong to each filesystem, and it uses filesystem UUID for this
>> purpose.
>>
>> If you clone a filesystem (for instance using dd or lvm snapshotting,
>> doesn't matter how) and then trigger a btrfs device scan, say by plugging
>> in some other device with btrfs on it so udev triggers a scan, and the
>> kernel sees multiple devices with the same filesystem UUID as a result,
>> and one of those happens to be mounted, you can corrupt both copies as
>> the kernel btrfs won't be able to tell them apart and may write updates
>> to the wrong one.
>
> That seems like a rather odd design. Why isn't btrfs refusing to mount
> in this situation? In the face of ambiguity, guessing is generally bad
> idea (at least for a computer program).

The logic  you describe requires code. It's the absence of code rather
than an intentional design that's the cause of the current behavior.
And yes, it'd be nice if Btrfs weren't stepping on its own tail in
this situation. It could be as simple as refusing to mount anytime
there's an ambiguity, but that's sorta user hostile if there isn't a
message that goes along with it to help the user figure out a way to
resolve the problem. And that too could be fraught with peril if the
user makes a mistake. So, really what's the right way to do this is
part of the problem but I agree it's better to be hostile and refuse
to mount a given volume UUID at all when too many devices are found,
than corrupt the file system.

-- 
Chris Murphy
