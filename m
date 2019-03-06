Return-Path: <SRS0=mVxD=RJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17656C43381
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 20:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0D9E20684
	for <linux-btrfs@archiver.kernel.org>; Wed,  6 Mar 2019 20:36:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="hm6CZX02"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726297AbfCFUgU (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 6 Mar 2019 15:36:20 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:34699 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfCFUgU (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Mar 2019 15:36:20 -0500
Received: by mail-lj1-f195.google.com with SMTP id l5so12156952lje.1
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Mar 2019 12:36:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O2XqvZ7S1e2gR4NR/PXJQLyR4922qprBQ0/5nYEzETA=;
        b=hm6CZX0243jNxGMhQDQ9mvb26TpuhFCvc2jicGGA6K1TPGHvOQT8qkK5iMcb79ZQa1
         Al77SV2t1YZz5ASJ7aiArbIM309udsDGrvsVoZWcQjp6HF7x6H/EvsZC5SVV+MJOqiaj
         G29d3zL5hosFghn8mXfxWw23n+AJ9n4UXlhB4NU7kmWekfTgzVOqALpfQLh6uhMdK83C
         rRwNfKJCdIH0amYbWO9wIo9JNedsUlzM3xRxgguSzDcwQ3kLSr2dcz4TQYCf17aa3U7y
         RybYrD+9WwC/GhaRB4GjF0MC8Vs7hs0n4MFXyPuHIIEUH0FUBbwe5CTDactayLsxZiuQ
         GPuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O2XqvZ7S1e2gR4NR/PXJQLyR4922qprBQ0/5nYEzETA=;
        b=kWryOVO7C2XIb2++kjAfjZhP3fqY98hol/nL08mulajkm51OUCCtDLdCzguuFf03BZ
         WmOzNRqX/7YhZFL2+SYJK4b59B1yHr9DgFltWnre4nWM9Gn1aoOx2UUCmVAMz603s0w8
         Hoj46b0JGQcElUH+LYAob+5jd5TPm+fdllJ5vdRddjlMMwSLtsUKm4aF6UCftGc89Ejj
         se/ONhLHC+7Fl8YSZmTC8s7ZQ348K67mTUuZFqOZSGDiWdyl0mk91/GK/TnyhpSD6WPU
         tNP6oaS6VIIZLEHFi95Dd0O1Z/ckFGoBs9euL/vU4jNTAdlMCgP0S8YFYpjXkVlm+Kk3
         BgJw==
X-Gm-Message-State: APjAAAVgw6gjnCXXV2zl62fREP+oQ7GWZNqQ/TY9r9XCOUIyRYfvURaK
        7RtIhsi3fzfL3V6mQf5uUZPAchfDKMtwouubADC01TKBZVY=
X-Google-Smtp-Source: APXvYqwDrLh4rU7pVIy0OanHX1w1BJl2TZrbbn9L1zHfUAsVM8pk3w/I4dsZxyX7hj6zRLMMQrnN0PyFBX1WdHAEfa0=
X-Received: by 2002:a2e:8701:: with SMTP id m1mr3544594lji.132.1551904577155;
 Wed, 06 Mar 2019 12:36:17 -0800 (PST)
MIME-Version: 1.0
References: <3ac57b0b1d8a4060b7411b4b3db5c52f@nevion.com>
In-Reply-To: <3ac57b0b1d8a4060b7411b4b3db5c52f@nevion.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Wed, 6 Mar 2019 13:36:05 -0700
Message-ID: <CAJCQCtRYqB4E6TTjepgRQdDp3637iTgXJHHT+_wBM0Pb75tjSA@mail.gmail.com>
Subject: Re: btrfs filesystem failing with 'No space left on device' after 4 hours
To:     Michael Firth <MFirth@nevion.com>
Cc:     "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 6, 2019 at 7:29 AM Michael Firth <MFirth@nevion.com> wrote:
>
> Hi,
>
> I have a BTRFS filesystem that seems to have become very ill. After 4 hou=
rs of being mounted, it will fail with every write attempt saying "No space=
 left on device".

What program/process is trying to write to the volume? Even "touch
~/hello" fails with this message? What happens if you strace the
command? If you strace and output to a file, make sure you direct the
file to a file system OTHER than root and the file system you've had
this problem with (redirect it to a USB stick or to /tmp), but if the
problem happens even with touch, or writing some zeros with dd, you
should be able to strace just to std out and copy paste the results
into a file.


>
> Unmounting and remounting the filesystem clears the issue for another 4 h=
ours
>
> From every check I have done, no messages are logged at the point of the =
failure to "dmesg" or any system log.

The lack of a message doesn't sound like the usual enospc. If the file
system runs out of space, even if it's wrong and it's a bug, Btrfs
will warn or info in dmesg.



>
> The output of the three (why on earth are there three?) disk space comman=
ds on the filesystem are:

The three come from different eras, and the legacy 'btrfs filesystem
df' and 'btrfs filesystem show' commands were kept around for script
support I assume. I personally find it ridiculous, but also I know
developers are busy with other important issues. I think there should
be one command for humans and when meaningful improvements are made,
the old way is flat out removed. And there should be a switch to
output machine readable raw spew for scripts and such. But whatever,
not up to me!



>
> From my understanding of the output in this, there don't seem to be any a=
reas that are even close to full. And if it was a genuine full condition, e=
ven due to running out of metadata or something, then I wouldn't expect unm=
ounting and remounting to clear the issue.

Yep, it's suspicious that it is kernel related. But there's a lot that
happens at umount (you can strace umount and see some of it!) that's
not just implicating Btrfs as a possible cause. It could be something
else. The lack of Btrfs errors strongly suggests it's not directly
related to Btrfs. The program is getting some idea that there's no
space left so that needs to be tracked down why it thinks this. Btrfs
doesn't think that because when it does, it reports it to dmesg.

I don't know anything about Debian and its default kernel console
message logging level, but sometimes I see for some distros that
'dmesg -n 7' needs to be issued before reproducing a problem. Maybe in
your case a hint is just not being retained by dmesg? If you're
running systemd an alternative is to get kernel messages from
'journalctl -k' for the current boot; or also 'journalctl -k
--no-pager' or output with monotonic time 'journalclt -k -o
short-monotonic > journal.txt' and so on.


> Is there any known issue that may cause this behaviour?

This list is upstream development. You'll find on ext4 and XFS list a
similar notion that distro kernels are supported by distros, not
upstream. It's a function of almost pure luck if you get the attention
of a developer who knows something about a 2 year old kernel. And 4.9
is more than 2 years old from a Btrfs development perspective, closer
to three years. Current development is happening on kernel 5.2; where
bug fixes are happening for 5.1. For practical purposes it's ordinary
to be asked to use a mainline or stable (5.0 or 4.20) kernel to see if
the problem still happens. If it does, then you've likely discovered
an unfixed bug. If it doesn't happen, you've discovered a fixed bug.
For various reasons it can be difficult to backport all bug fixes so
maybe it's in a 4.19 Debian built kernel, you'd have to test it. But
the way to limit the testing as much as possible is go straight to
5.0. If it happens there you've almost certainly found a bug that's
not yet fixed.

But even before changing kernels in your case I suggest stracing the
simplest program that reproduces the error, like even touch or cp. We
need to have some idea why the program thinks there's no more space
left while the kernel isn't reporting it.





>
> Is there any way to get more debugging from what is going on?

dmesg -n 7
and reproduce with strace + some simple command simpler reproduction the be=
tter



>
> My initial thought was that it might be related to snapshots, as I was ge=
nerating regular snapshots (for a 'previous versions' feature), and many of=
 the failures were just after a snapshot was created. However, I have now d=
isabled the snapshot creation and I am still seeing regular failures.

Could be one of the edge cases that was fixed in 4.12 but off hand I'd
guess those went back to 4.9. But there have been other edge case
fixes for enospc since then. Note that every merge cycle for the
kernel, Btrfs sees ~1000-2000 commits. It's a lot of changes to keep
track of in someone's memory when it's literally tens of thousands of
changes since kernel 4.9.


--=20
Chris Murphy
