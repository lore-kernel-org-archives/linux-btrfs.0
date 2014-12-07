Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42719 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbaLGPkz (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 10:40:55 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
Date: Sun, 07 Dec 2014 16:40:54 +0100
Message-ID: <1610909.CxuY1Bb9iL@merkaba>
In-Reply-To: <44320137.fRRuR6EFMP@merkaba>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com> <44320137.fRRuR6EFMP@merkaba>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 7. Dezember 2014, 16:33:37 schrieb Martin Steigerwald:
> What might be possible but still has the limitation of the fourth point
> above,  would be a query: How much free space do you have *right* know, on
> this directory path, if I write with standard settings.
> 
> But the only guarantee you can ever get is to pre-allocate your files with 
> fallocate. When the fallocate file succeeded, you get a guarantee that you
> can  write to the amount of allocated space into the file. Whether BTRFS
> can hold to that guarantee in any case? That depends on how bug free it is
> in that regard with its free space handling.

Well what would be possible I bet would be a kind of system call like this:

I need to write 5 GB of data in 100 of files to /opt/mynewshinysoftware, can I 
do it *and* give me a guarentee I can.

So like a more flexible fallocate approach as fallocate just allocates one file 
and you would need to run it for all files you intend to create. But challenge 
would be to estimate metadata allocation beforehand accurately.

Or have tar --fallocate -xf which for all files in the archive will first call 
fallocate and only if that succeeded, actually write them. But due to the 
nature of tar archives with their content listing across the whole archive, 
this means it may have to read the tar archive twice, so ZIP archives might be 
better suited for that.

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
