Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:55060 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552Ab2FMJ5U (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jun 2012 05:57:20 -0400
Received: by yenm10 with SMTP id m10so329530yen.19
        for <linux-btrfs@vger.kernel.org>; Wed, 13 Jun 2012 02:57:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGAVQTGJrUoZ3SdoqmTadkZZst6TkbNoAHmRSXvJ7JEB3FTA+g@mail.gmail.com>
References: <1339183466.55421.YahooMailNeo@web160803.mail.bf1.yahoo.com>
	<4FD2552D.20003@gmx.net>
	<CAGAVQTGctBTEKTCvhNbAsw7zMg5NfBm8n=Kf=wULKRNm5LQSjQ@mail.gmail.com>
	<4FD83F75.5000600@gmx.net>
	<CAGAVQTGJrUoZ3SdoqmTadkZZst6TkbNoAHmRSXvJ7JEB3FTA+g@mail.gmail.com>
Date: Wed, 13 Jun 2012 16:57:19 +0700
Message-ID: <CAG1y0scdjtvgGa0CK3pKD1ZRO696KJPjZGchXS7e-tT+Z978Sg@mail.gmail.com>
Subject: Re: Moving top level to a subvolume
From: "Fajar A. Nugraha" <list@fajar.net>
To: C Anthony Risinger <anthony@xtfx.me>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 13, 2012 at 4:44 PM, C Anthony Risinger <anthony@xtfx.me> wrote:
> On Wed, Jun 13, 2012 at 2:21 AM, Arne Jansen <sensille@gmx.net> wrote:
>> On 13.06.2012 09:04, C Anthony Risinger wrote:

>>> ... because in a), data will *copied* the slow way

>> What I don't understand is why you think data will be copied.

> at one point i tried to create a new subvol and `mv` files there, and
> it took quite some time to complete
> (cross-link-device-what-have-you?), but maybe things changed ... will
> try it out.

IIRC it hasn't. Not in upstream anyway. Some distros (e.g. opensuse)
carry their own patch which allows cross-subvolume links (cp --reflink
...).

But it shouldn't matter anyway, since you can SNAPSHOT the old subvol
(even root subvol), instead of creating a new subvol. Which means
nothing needs to be copied.

You'd still have to do "rm" manually though.

-- 
Fajar
