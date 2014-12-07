Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57769 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753005AbaLGSi2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 7 Dec 2014 13:38:28 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: ashford@whisperpc.com
Cc: Shriramana Sharma <samjnaa@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Why is the actual disk usage of btrfs considered unknowable?
Date: Sun, 07 Dec 2014 19:38:22 +0100
Message-ID: <2268945.SsYGbSXAx5@merkaba>
In-Reply-To: <88937b9f24bc72160d80977c9edefba2.squirrel@webmail.wanet.net>
References: <CAH-HCWU9GEjvZLH=rwYev_O0S4_Cs9FJvRiJgBiOK8gdxqK5CQ@mail.gmail.com> <44320137.fRRuR6EFMP@merkaba> <88937b9f24bc72160d80977c9edefba2.squirrel@webmail.wanet.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sonntag, 7. Dezember 2014, 10:20:27 schrieb ashford@whisperpc.com:
> Martin,
> 
> > I read that the actual
> > what is free is unknown. And there are several reasons for that:
> > 
> > 1) On a compressed filesystem you cannot know, but only estimate the
> > compression ratio for future data.
> 
> It is NOT the job of BTRFS, or ANY file-system, to try to prodict the
> future.  The future is unknown.  Don't try to account for it.  When asked
> for the status (i.e. 'df'), it should return the current status.
> 
> > 2) On a compressed filesystem you can choose to have parts of it
> > uncompressed by file / directory attributes, I think. BTRFS can't
> > know how much of the
> > future data you are going to store compressed or uncompressed.
> 
> Same as above.

What is the point you are trying to make?

I just described the reasons on what problems there are with trying to predict 
available free space, with BTRFS as an example. Some points apply to all 
filesystems, some do not, so what is the point you are trying to make?

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
