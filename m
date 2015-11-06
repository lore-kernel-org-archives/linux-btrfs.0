Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:33456 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161220AbbKFNhb (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 6 Nov 2015 08:37:31 -0500
Received: by pabfh17 with SMTP id fh17so123453281pab.0
        for <linux-btrfs@vger.kernel.org>; Fri, 06 Nov 2015 05:37:31 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56327B01.7010002@gmail.com>
References: <CA+9GZUiUNiRJOjwhxZaE06GdfcLQBpWfY5kpkpmLhD6eg_cg4g@mail.gmail.com>
 <CA+9GZUi9jiJ9RBezrh7Xi4_1eBpyeNBdrs+hYxsECaa_a9_csA@mail.gmail.com>
 <CA+9GZUipGeuNuVP2=g2+gbWpJWxbeHVQEcQ5QYfOCWjkv5JDcQ@mail.gmail.com>
 <CA+9GZUhAZRYto0Rm3Edy0j3gFfGZbfWpqunA3vzraxwh-ANORg@mail.gmail.com>
 <CA+9GZUjTt7C4rjSgui3M65S_WEQ3zsLEjw39x=_Ots=N8Jn3eg@mail.gmail.com>
 <562F638B.1040701@gmail.com> <BLU436-SMTP2188EE1DBF30D4E50D6F3DA9220@phx.gbl>
 <562F7C7B.6060408@gmail.com> <CA+9GZUg3LxLqdqUATHVyLMsDYkH1FfvawtGZgKAv46qNsuZ-xQ@mail.gmail.com>
 <CA+9GZUioamT+urUtZRvyv-hkurDpqH8A_f-L9ge9nUsq_tL=8w@mail.gmail.com>
 <CA+9GZUhXfVyJd9CKb2RSms4g6YQUue+z7N54+=SKUmzrwqg4xw@mail.gmail.com>
 <CA+9GZUhtS9Y-711VSaS1-ie92x9FtZFHw5WZ5__+YgbGneU9kA@mail.gmail.com>
 <562F97B5.8000108@gmail.com> <CA+9GZUhKmH9x_D6r=P8p=E4H38t+jcUQd1bFeVeE_uj1GyTA8A@mail.gmail.com>
 <56322679.8050001@gmail.com> <CA+9GZUgf3RxzuY2zjqggDsObBO9se1NMiSxFvM9VX3cLC7AfvQ@mail.gmail.com>
 <56327B01.7010002@gmail.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Fri, 6 Nov 2015 14:37:11 +0100
Message-ID: <CA+9GZUhgVBzfdowkR_EagSdsN5HNGi_uPQM=AE2TeWQQ0idymQ@mail.gmail.com>
Subject: Re: Bad fs performance, IO freezes
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, Henk Slager <hslager@hotmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I am getting a sata dock for my laptop next week. Until then, is it
possible to perform an action in btrfs (like rm which seems to trigger
the issue) and make it log what exactly it's doing?


On Thu, Oct 29, 2015 at 9:01 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-10-29 11:49, cheater00 . wrote:
>>
>> Hi Austin,
>> seek times are fine, but this literally freezes my computer for a
>> split second. I've had to re-type this email twice because the freezes
>> meant letters I typed would not arrive on the screen.
>> USB disks are so common they should not be having issues.
>
> That's debatable.  USB is commonly used because it's almost impossible to
> find a system that doesn't have it, not because it's reliable.  The original
> intent was for it to be used for stuff like mice and keyboards, so it was
> designed with low-latency and fair scheduling in mind, both of which really
> hurt performance of bulk data storage devices.
>>
>> I have 4.3.0-040300rc7-generic #201510260712 which is just three days old.
>
> That should be perfectly recent enough, although FWIW, the official version
> of 4.3 should be out this Sunday.
>>
>>
>> Please advise. Isn't it better to *not* use a vm to debug this?
>
> That depends.  For something like this, it could go either way.  I just use
> a VM because that's what I always use, because it's nice not crashing your
> system when trying to debug a kernel panic.
>>
>> BTW, if we are talking about slow speed making things worse, I could
>> try downgrading the cable to usb2.
>> Is there a standard virtualbox VM that I could use?
>
> In general, it's pretty easy to set something like Ubuntu up in VirtualBox,
> the install is essentially identical to regular hardware aside from the
> initial setup of the VM itself.  The documentation for VirtualBox is really
> good, if you've never used virtualization before, it's definitely worth
> reading.
>>
>> I'll download Gentoo in the meantime. I have never used it. I'm
>> getting the "minimal installation cd" from 29th september.
>>
>> http://distfiles.gentoo.org/releases/x86/autobuilds/20150929/install-x86-minimal-20150929.iso
>
> I meant by no means that you needed to use Gentoo, I only mentioned it
> because it's what I use (which in turn is because that's what I use on just
> about everything except stuff like the Raspberry Pi or the BeagleBoard).  If
> you just want to debug this and then be done with it, I would actually
> advise against using Gentoo, it takes a lot of effort to get a system up and
> running with it, and it's very involved to maintain compared to Ubuntu.  On
> the other hand though, if you are willing to learn to use it, it's one of
> the most highly customizable Linux distros out there, and can have
> noticeably better performance than more generic distros (FWIW, it's also one
> of the last big distros that doesn't force systemd on it's users by
> default).
>
