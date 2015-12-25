Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:35546 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbbLYTBY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Dec 2015 14:01:24 -0500
Received: by mail-lf0-f54.google.com with SMTP id l133so174725453lfd.2
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Dec 2015 11:01:23 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <16107.1451037790@ccs.covici.com>
References: <16107.1451037790@ccs.covici.com>
Date: Fri, 25 Dec 2015 20:01:22 +0100
Message-ID: <CAPmG0jbOu6BmKfbaoJ6pzprWzbch3tf7=zbBS8AcDz4MQVEJZA@mail.gmail.com>
Subject: Re: btrfs problems on new file system
From: Henk Slager <eye1tm@gmail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 25, 2015 at 11:03 AM,  <covici@ccs.covici.com> wrote:
> Hi.  I created a file system using 4.3.1 version of btrfsprogs and have
> been using it for some three days.  I have gotten the following errors
> in the log this morning:
> Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> transid verify failed on 51776421888 wanted 4983 found 4981
> Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> transid verify failed on 51776421888 wanted 4983 found 4981
> Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> transid verify failed on 51776421888 wanted 4983 found 4981
> Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> transid verify failed on 51776421888 wanted 4983 found 4981
> Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> transid verify failed on 51776421888 wanted 4983 found 4981
> Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> transid verify failed on 51776421888 wanted 4983 found 4981
> Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> transid verify failed on 51776421888 wanted 4983 found 4981
> Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> transid verify failed on 51776421888 wanted 4983 found 4981
> Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> transid verify failed on 51776421888 wanted 4983 found 4981
> Dec 25 04:10:16 ccs.covici.com kernel: BTRFS (device dm-20): parent
> transid verify failed on 51776421888 wanted 4983 found 4981
>
> The file system was then made read only.  I unmounted, did a check
> without repair which said it was fine, and remounted successfully in
> read/write mode, but am I in trouble?  This was on a solid state drive
> using lvm.
What kernel version are you using?
I think you might have some hardware error or glitch somewhere,
otherwise I don't know why you have such errors. These kind of errors
remind me of SATA/cable failures over quite a period of time (multipe
days). Or something with lvm or trim of SSD.
Any unusual with the SSD if you run  smartctl?
A btrfs check will indeed likely result in an OK for this case.
What about running read-only scrub?
Maybe running  memtest86+  can rule-out the worst case.
