Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:33675 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbbJ2PuL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 11:50:11 -0400
Received: by padhy1 with SMTP id hy1so38426203pad.0
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2015 08:50:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56322679.8050001@gmail.com>
References: <CA+9GZUiUNiRJOjwhxZaE06GdfcLQBpWfY5kpkpmLhD6eg_cg4g@mail.gmail.com>
 <562E37F4.9080602@oracle.com> <CA+9GZUjnrdA-O24bbY4KGAxcLOk26uohS8cF+Z=vLjOT88-rwQ@mail.gmail.com>
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
 <56322679.8050001@gmail.com>
From: "cheater00 ." <cheater00@gmail.com>
Date: Thu, 29 Oct 2015 16:49:51 +0100
Message-ID: <CA+9GZUgf3RxzuY2zjqggDsObBO9se1NMiSxFvM9VX3cLC7AfvQ@mail.gmail.com>
Subject: Re: Bad fs performance, IO freezes
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, Henk Slager <hslager@hotmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Austin,
seek times are fine, but this literally freezes my computer for a
split second. I've had to re-type this email twice because the freezes
meant letters I typed would not arrive on the screen.
USB disks are so common they should not be having issues.
I have 4.3.0-040300rc7-generic #201510260712 which is just three days old.

Please advise. Isn't it better to *not* use a vm to debug this?
BTW, if we are talking about slow speed making things worse, I could
try downgrading the cable to usb2.
Is there a standard virtualbox VM that I could use?
I'll download Gentoo in the meantime. I have never used it. I'm
getting the "minimal installation cd" from 29th september.
http://distfiles.gentoo.org/releases/x86/autobuilds/20150929/install-x86-minimal-20150929.iso

On Thu, Oct 29, 2015 at 3:00 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-10-29 09:03, cheater00 . wrote:
>>
>> Hi Liu,
>> after talking with Holger I believe turning off COW on this FS will
>> work to alleviate this issue. However, even with COW on, btrfs
>> shouldn't be making my computer freeze every 5 seconds... especially
>> while the disk is written to at mere tens of kilobytes per second.
>> It's not even the disk holding the system. I consider this a pretty
>> bad bug... should we go on with trying to reproduce a minimum case?
>> How would I go about this?
>
>
> Well, COW can cause some pretty unexpected behavior for some use cases.  If
> you have a big disk (I think I remember you saying it was larger than 1TB),
> then COW can cause some pretty significant seek times because of how it
> works.  With the current state of BTRFS, I wouldn't personally consider
> running BTRFS on anything bigger than 256G with a non-zero seek time with
> COW turned on, because large rewrites would have the potential to cause
> horrifically long seek times just for a RMW cycle on a single block, and
> this is in turn part of why database files and virtual-machine images tend
> to be pathological use cases for BTRFS.
>
> I do agree that this kind of thing is a bug, but it's not something that
> causes data corruption, which means that it is slightly lower priority as
> far as most people are concerned.  Reproducing it might be tricky also,
> because I'd be willing to bet that things get better to the point of it
> being almost unnoticeable with an internal disk (USB is horrible when it
> comes to block storage performance, and has all kinds of potential
> reliability issues).
>
> Normally, when I try to go about reproducing something like this, I use a
> virtual machine running the most recent stable version of the Linux kernel,
> usually with a minimalistic Gentoo installation (although a clean install of
> pretty much any distro works fine).  There are a couple of reasons I use
> such a setup:
> 1. Using a clean install provides a well defined initial state, making it
> easier for other people to reproduce any results.
> 2. Using the most recent stable kernel available (usually) eliminates the
> chances of old bugs causing issues.
> 3. Using a VM means that your disk access will be slower, which will visibly
> accentuate any kind of performance issues.
> 4. Using a VM also means that it is very easy to safely generate crash dumps
> and simulate data corruption for testing purposes, and makes it easier to
> experiment with different parameters (for example, UP versus SMP, or
> different amounts of RAM).
>
> If you do decide to go this route, my suggestion would be to use VirtualBox
> unless you have significant experience with some other hypervisor, as it's
> one of the easiest to learn to use (I usually use Xen or QEMU, but both
> require significant effort to set up initially, and are decidedly
> non-trivial to learn), and learning to debug stuff like this is itself not
> an easy task.
>
