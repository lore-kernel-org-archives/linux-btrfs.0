Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qa0-f52.google.com ([209.85.216.52]:63644 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaHaCRP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 30 Aug 2014 22:17:15 -0400
Received: by mail-qa0-f52.google.com with SMTP id f12so3766443qad.11
        for <linux-btrfs@vger.kernel.org>; Sat, 30 Aug 2014 19:17:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <or61h94yvf.fsf@free.home>
References: <or61h94yvf.fsf@free.home>
Date: Sun, 31 Aug 2014 07:47:14 +0530
Message-ID: <CAH-HCWXacJOstUxtsESRkWjZnxRZ_kmSKNiTO22qTyek+D+CMw@mail.gmail.com>
Subject: Re: btrfs: add -k option to filesystem df
From: Shriramana Sharma <samjnaa@gmail.com>
To: Alexandre Oliva <oliva@gnu.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/30/14, Alexandre Oliva <oliva@gnu.org> wrote:
> Introduce support for df to print sizes in KiB, easy to extend to other
> bases.

Hello. I'm glad to see this as I have been a fan of the binary units
for long (since they were introduced)!

However I feel the chosen long option could be improved as it reads
"kbytes" and:

1) currently SI units are being displayed as "kbytes" exist there too

2) it sounds as if it is intended to force display in kbytes only
whereas that is not the case.

What is actually being introduced is IEC units for the sizes. So --iec
and -i would be better choices for the options. Since btrfs fi df
currently doesn't seem to have any options (I am only looking at the
3.12 version on my system) this should not conflict with anything
else.

BTW this site: http://ram.kossboss.com/btrfs-fi-df-balance-btrfs-df/
seems to already show IEC units -- perhaps is it Alexandre's site?!

-- 
Shriramana Sharma ஶ்ரீரமணஶர்மா श्रीरमणशर्मा
