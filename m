Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43551 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbbAXOOz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 24 Jan 2015 09:14:55 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Chris Mason <clm@fb.com>
Cc: Holger =?ISO-8859-1?Q?Hoffst=E4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: 3.19-rc5: Bug 91911: [REGRESSION] rm command hangs big time with deleting a lot of files at once
Date: Sat, 24 Jan 2015 15:14:53 +0100
Message-ID: <1609126.kYbLECeJBA@merkaba>
In-Reply-To: <1422025014.28436.1@mail.thefacebook.com>
References: <2506104.3YBgc9qdaM@merkaba> <pan.2015.01.23.14.38.09@googlemail.com> <1422025014.28436.1@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Freitag, 23. Januar 2015, 09:56:54 schrieb Chris Mason:
> On Fri, Jan 23, 2015 at 9:38 AM, Holger Hoffstätte
> 
> <holger.hoffstaette@googlemail.com> wrote:
> > On Fri, 23 Jan 2015 15:01:28 +0100, Martin Steigerwald wrote:
> >>  Hi!
> >>  
> >>  Anyone seen this?
> >> 
> >>  Reported as:
> >> https://urldefense.proofpoint.com/v1/url?u=https://bugzilla.kernel.or
> >> g/show_bug.cgi?id%3D91911&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0l
> >> zzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=fHpzX%2FNpDGcY26Q1T%2B0VtIyZz0GPMnG3qv
> >> E%2FVJ%2Blsf0%3D%0A&s=66b06542cc5a9585c9913a0b76885b4baba0a8028f70149
> >> 803982388c9333d71> 
> > You might be interested in:
> > 
> > https://urldefense.proofpoint.com/v1/url?u=https://git.kernel.org/cgit
> > /linux/kernel/git/josef/btrfs-next.git/commit/?h%3Devict-softlockup%26
> > id%3D29249e14d6e3379a5c4bb098dd4beddfefbc606f&k=ZVNjlDMF0FElm4dQtryO4A
> > %3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=fHpzX%2FNpDGcY26Q1T%
> > 2B0VtIyZz0GPMnG3qvE%2FVJ%2Blsf0%3D%0A&s=137b101ca50e644b95dc2b14758cf1
> > 472e9cc0097b4f89f7edf8e2845455b20f
> > 
> > and
> > 
> > https://urldefense.proofpoint.com/v1/url?u=https://git.kernel.org/cgit
> > /linux/kernel/git/josef/btrfs-next.git/commit/?h%3Devict-softlockup%26
> > id%3De4a58b71ff981b098ac3371f4d573dc6a90006ce&k=ZVNjlDMF0FElm4dQtryO4A
> > %3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=fHpzX%2FNpDGcY26Q1T%
> > 2B0VtIyZz0GPMnG3qvE%2FVJ%2Blsf0%3D%0A&s=3462ceb04ffed8316e21ffe16eee4e
> > 3274f9771a58326cd1bbb9c1cfc1eef9ba
> > 
> > I'm sure everyone would love to hear how this works out for you ;-)
> 
> These are a little different.  Josef is fixing softlockups (CPUs pegged
> in R state) while this bug report is for sleeping procs.  The fact that
> things come back sound like we're pegged waiting for IO?  Do you have a
> lot of writing going on at the same time?

Who? Me?

No. Akonadi was quite silent at this time. According to atop the SSDs 
where basically idle. It just locked. 

-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
