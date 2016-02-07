Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f49.google.com ([209.85.215.49]:33190 "EHLO
	mail-lf0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbcBGNmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Feb 2016 08:42:00 -0500
Received: by mail-lf0-f49.google.com with SMTP id m1so82946127lfg.0
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Feb 2016 05:41:59 -0800 (PST)
MIME-Version: 1.0
Reply-To: a.t.hild@gmail.com
In-Reply-To: <56B7462B.8060403@bouton.name>
References: <CAEm4ggmjK8oH7PcN_-Jf3M-j=8Yewh6j3G2F+zUviaajY1wgow@mail.gmail.com>
	<56B7462B.8060403@bouton.name>
Date: Sun, 7 Feb 2016 20:41:58 +0700
Message-ID: <CAEm4gg=7x875jAvXsVKgVfA3K3v+r03xeOOguzftS267B9YRBg@mail.gmail.com>
Subject: Re: Fi corruption on RAID1, generation doesn't match
From: Andreas Hild <a.t.hild@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 7 February 2016 at 20:27, Lionel Bouton
<lionel-subscription@bouton.name> wrote:
> Hi,
>
> Le 07/02/2016 14:15, Andreas Hild a écrit :
>> Dear All,
>>
>> The file system on a RAID1 Debian server seems corrupted in a major
>> way, with 99% of the files not found. This was the result of a
>> precarious shutdown after a crash that was preceded by an accidental
>> misconfiguration in /etc/fstab; it pointed "/" and "/tmp" to one and
>> the same UUID by omitting a subvol entry.
>>
>> Is there any way to repair or recover a substantial part of this RAID?
>
> I don't think the RAID is damaged: most distributions including Debian
> remove nearly all files from /tmp at boot.
> If /tmp and / were as you described the same filesystem your server most
> probably did what amounts to "rm -rf /". You would probably have got the
> same result with any filesystem as mounting the same filesystem at
> several points in the VFS is not BTRFS-specific.
>
> Unless you can restore a snapshot or there is a way to debug the
> filesystem to restore a previous state, I'm afraid there's nothing to be
> done.


Thank you for the fast response!

I see. Just to be certain here, I have noted a vast difference between
the output of the "regular" 'df' and 'btrfs fi df'. Regular df shows
about 85MB of data on this file system, whereas btrfs fi df shows the
expected 168.00GiB (the exact amount of data that was there).

What does this mean?


Best wishes,
Andreas
