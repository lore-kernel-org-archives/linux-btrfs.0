Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:36358 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758085AbcDHSFe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 14:05:34 -0400
Received: by mail-ig0-f169.google.com with SMTP id f1so18913658igr.1
        for <linux-btrfs@vger.kernel.org>; Fri, 08 Apr 2016 11:05:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5707961D.6000803@gmail.com>
References: <CAFKQ2BsxWYejWOPMCw5JuF-SXM03-papUu6LXM5KBNKthxAPxg@mail.gmail.com>
	<CAJCQCtQCLWca9YycOSTC8Q4c78a8AVe7uFXAoe2vqEUQVFHiNA@mail.gmail.com>
	<57064231.2070201@gmail.com>
	<CAJCQCtSAaTYYMJhTTAsEXXDUzUdLEpJARHPRfihDNZrvZtEo4Q@mail.gmail.com>
	<5707961D.6000803@gmail.com>
Date: Fri, 8 Apr 2016 12:05:32 -0600
Message-ID: <CAJCQCtQwNDoB75XYdsdcvedbnc1ox3YOi8aaiw0DZ=1Q=21WBw@mail.gmail.com>
Subject: Re: unable to mount btrfs pool even with -oro,recovery,degraded,
 unable to do 'btrfs restore'
From: Chris Murphy <lists@colorremedies.com>
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Ank Ular <ankular.anime@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 8, 2016 at 5:29 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> I entirely agree.  If the fix doesn't require any kind of decision to be
> made other than whether to fix it or not, it should be trivially fixable
> with the tools.  TBH though, this particular issue with devices disappearing
> and reappearing could be fixed easier in the block layer (at least, there
> are things that need to be fixed WRT it in the block layer).

Another feature needed for transient failures with large storage, is
some kind of partial scrub, along the lines of md partial resync when
there's a bitmap write intent log.


-- 
Chris Murphy
