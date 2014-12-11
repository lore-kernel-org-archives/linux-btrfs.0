Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:54364 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932521AbaLKRSV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Dec 2014 12:18:21 -0500
Received: by mail-oi0-f48.google.com with SMTP id u20so3920859oif.35
        for <linux-btrfs@vger.kernel.org>; Thu, 11 Dec 2014 09:18:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan.2014.12.11.12.37.56@googlemail.com>
References: <pan.2014.12.11.12.37.56@googlemail.com>
Date: Thu, 11 Dec 2014 17:18:20 +0000
Message-ID: <CALOYprXnoixE6L9eY+1_8BvT=2gu0N_6u3MfwkC57qgPPO0jww@mail.gmail.com>
Subject: Re: Announcements for btrfs-progs?
From: WorMzy Tykashi <wormzy.tykashi@gmail.com>
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11 December 2014 at 12:37, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:
>
> David,
>
> I was wondering if you could please send out announcements for btrfs-progs
> when you tag a release or -rc? There doesn't seem to be a good mechanism
> to track releases and IMHO the more people are notified, the more
> testing we can get, not to mention faster propagation into distros.
>
> Thanks,
>
> Holger
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Holger,

I agree that announcements would be good, but I'd still like to point
out that, since the btrfs-progs repository is mirrored on github, you
can use the poorly advertised atom feed to keep track of tags:
https://github.com/kdave/btrfs-progs/releases.atom

Alas, there is no such feature for watching branches (it was
apparently discontinued). So I would (also) like to see announcements
when a new integration branch is made public. At present, I rely on
manually checking the branch list periodically.

Cheers,


WorMzy

(resent to btrfs mailing list too)
