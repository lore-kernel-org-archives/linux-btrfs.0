Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:33837 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaLGPiA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 10:38:00 -0500
Received: by mail-qa0-f52.google.com with SMTP id dc16so2377632qab.25
        for <linux-btrfs@vger.kernel.org>; Sun, 07 Dec 2014 07:37:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <44320137.fRRuR6EFMP@merkaba>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com>
 <44320137.fRRuR6EFMP@merkaba>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Sun, 7 Dec 2014 21:07:39 +0530
Message-ID: <CAH-HCWVHmG5CrAXs1SWiTF1V8kBQ0A3OZ-PH7UVnjHE9Dkq7rg@mail.gmail.com>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 7, 2014 at 9:03 PM, Martin Steigerwald <Martin@lichtvoll.de> wrote:
>
> I never read that the actual disk usage is unknown. But I read that the actual
> what is free is unknown. And there are several reasons for that:

That is totally understood. But I guess when your alloc space is
nearing 90% of your disk capacity, and used space is sorta 80% or so
of the alloc space, I guess it's a reasonable thing to expect that
people should add a drive to the pool, which btrfs makes so easy.
Given this, why do people complain about btrfs not being predictable
when it comes to ENOSPC?

Even with any other FS, I do think I'd not like my files to occupy
more than 90% or so since even then defrag would probably not work.

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
