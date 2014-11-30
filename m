Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:53937 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaK3X1Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 18:27:25 -0500
Received: by mail-ie0-f180.google.com with SMTP id rp18so8521968iec.11
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 15:27:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CANBHLUhHktgJRYR5JDjPmvq=299iDR3xmwoPTjFh5ey7DnFxZw@mail.gmail.com>
References: <547B5724.1060507@libero.it>
	<CANBHLUh9nXu4-wexFJimBvL-FtwPXQ7MeURi3COskJf-YJqGQA@mail.gmail.com>
	<CAE5mzvhOAi_Y2icLHOiUzG121ZALLZCTYhpjY8mkio3AyHrECA@mail.gmail.com>
	<CANBHLUhHktgJRYR5JDjPmvq=299iDR3xmwoPTjFh5ey7DnFxZw@mail.gmail.com>
Date: Sun, 30 Nov 2014 17:27:24 -0600
Message-ID: <CAE5mzvg_pUfj1axQ9F2ur247CG+foHBvBf+XN8qnmsz64SL=mw@mail.gmail.com>
Subject: Re: [RFC][PATCH v2] mount.btrfs helper
From: cwillu <cwillu@cwillu.com>
To: Dimitri John Ledkov <xnox@debian.org>
Cc: "kreijack@inwind.it" <kreijack@inwind.it>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        David Sterba <dsterba@suse.cz>,
        Zygo Blaxell <zblaxell@furryterror.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, misread "initrdless" as "initramfs".

In #btrfs, I usually say something like "do you gain enough by not
using an initfs for this to be worth the hassle?", but of course,
that's not an argument against making mount smarter.

On Sun, Nov 30, 2014 at 4:57 PM, Dimitri John Ledkov <xnox@debian.org> wrote:
> On 30 November 2014 at 22:31, cwillu <cwillu@cwillu.com> wrote:
>>
>> In ubuntu, the initfs runs a btrfs dev scan, which should catch
>> anything that would be missed there.
>>
>
> I'm sorry, udev rule(s) is not sufficient in the initramfs-less case,
> as outlined.
>
> In case of booting with initramfs, indeed, both Debian & Ubuntu
> include snippets there to run btrfs scan.
>
> --
> Regards,
>
> Dimitri.
