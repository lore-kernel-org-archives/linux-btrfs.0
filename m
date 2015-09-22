Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f49.google.com ([209.85.192.49]:35953 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561AbbIVObs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 10:31:48 -0400
Received: by qgx61 with SMTP id 61so117818174qgx.3
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Sep 2015 07:31:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <56015D3F.8020406@googlemail.com>
References: <20150922133813.GA14395@sfserver> <56015D3F.8020406@googlemail.com>
From: Richard Michael <rmichael@edgeofthenet.org>
Date: Tue, 22 Sep 2015 10:31:08 -0400
Message-ID: <CABR0jERXQ9ydE+KAeQBrW5F0DzraePnAyz8m-uVStUCbeFt4WQ@mail.gmail.com>
Subject: Re: problem with long running btrfs mount operation
To: =?UTF-8?Q?Holger_Hoffst=C3=A4tte?=
	<holger.hoffstaette@googlemail.com>
Cc: "S. Fricke" <silvio.fricke@gmail.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 22, 2015 at 9:53 AM, Holger Hoffstätte
<holger.hoffstaette@googlemail.com> wrote:
> On 09/22/15 15:38, S. Fricke wrote:
>> I have a problem with one of my btrfs hdds. If I mount it, it needs more than
>> 135 minutes for this operation. After the mounting it works normaly. This is
>> reproducible only with this hdd.
>>
>> Maybe someone has a clue what is going wrong here.
>
> On remount it tries to continue a previously started balance, which fails with
> an error (as can be seen at the end of your log). You should:
>
> a) immediately stop what you're doing on that fs and unmount it
> b) get btrfs-progs-4.2.1 (not 4.2) and see what it says
>
> Depending on the outcome of b) you can use -o skip_balance on the next mount.
>
> -h

I'm curious, do the relevant INFO lines also appear earlier in the
log, near the time the mount began?

These:

BTRFS: checking UUID tree
[  +0.000076] BTRFS info (device sda1): continuing balance


Otherwise, it requires an unknown amount of patience to diagnose this
problem -- how long should I wait before giving up?

It seems to me, from a sysadmin's perspective, the log messages are
reversed (hung task, 2+ hrs later, BTRFS tells me what it's doing) .
I'd expect BTRFS to log a "continuing balance" message as soon as I
mount it, then it's blocked [for as long as I care to wait], but I can
immediately tell what's happened.

Regards,
Richard
