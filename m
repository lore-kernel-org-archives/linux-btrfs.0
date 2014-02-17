Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:48530 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753629AbaBQNTd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Feb 2014 08:19:33 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Chris Mason <clm@fb.com>
Cc: Dave <dave@thekilempire.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [3.14-rc1] BUG: soft lockup - CPU#1 stuck for 22s with 255 GiB BTRFS with only 6 GiB free
Date: Mon, 17 Feb 2014 14:19:31 +0100
Message-ID: <2077161.YbeP0rnqkf@merkaba>
In-Reply-To: <5302096A.8070708@fb.com>
References: <16006080.zeFsK4Kcpx@merkaba> <2243736.htmPCRf1EE@merkaba> <5302096A.8070708@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Montag, 17. Februar 2014, 08:06:50 schrieb Chris Mason:
> On 02/17/2014 05:35 AM, Martin Steigerwald wrote:
> > Am Dienstag, 11. Februar 2014, 15:50:12 schrieb Dave:
> >> On Tue, Feb 11, 2014 at 10:36 AM, Martin Steigerwald
> >> 
> >> <Martin@lichtvoll.de> wrote:
> >>> Today I started getting those on 3.14-rc. One core as displayed as 100%
> >>> system CPU. I rebooted cause the system didn´t respond consistently to
> >>> user input anymore.
> >> 
> >> Does 3.14-rc1 have Joseph's delayed refs throttling code?  I had two
> >> separate machines that exhibited similar symptoms.  Chris's for-linus
> >> branch has a fix for this which solved my problems:
> >> https://urldefense.proofpoint.com/v1/url?u=https://git.kernel.org/cgit/li
> >> nux/kernel/git/mason/linux-btrfs.git/commit/?h%3Dfor-linus%26id%3D27a377d
> >> b745ed4d11b3b9b340756857cb8dde07f&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2
> >> FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=EO6xV8TuAFpGsdd9TfvXbfHYgIFA8%2BKZo1Kn
> >> Q%2BZ6yzU%3D%0A&s=c9c8769a12e5537247d6ef176681cf19e2bf80fef186ead748b8a2c
> >> d2bac6a85> 
> > I also got this now under 3.14-rc3 with almost 16 GiB left on heavy KMail
> > /
> > Akonadi activity. 3.14-rc3 includes above commit.
> > 
> > As I now also got it with more free space and never saw this with upto
> > 3.13 I think this is a regression.
> 
> Do we eventually recover or is it stuck like this forever?

Well I got the lock up again and again and watched it for some minutes until I 
lost patience and did a hard reboot, so I don´t know actually. Each lockup was 
about 22 or 23 seconds.

I will try to trigger that workload again. Since I freed 2-3 more GB, it may 
not trigger, but when it does, how long do you suggest me to wait for it to 
recover?

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
