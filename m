Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64689 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab2FFBLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jun 2012 21:11:15 -0400
Received: by dady13 with SMTP id y13so8035072dad.19
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jun 2012 18:11:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120605174638.69bcfa31.akpm@linux-foundation.org>
References: <cover.1338889066.git.joe@perches.com> <20120605142826.d92316a0.akpm@linux-foundation.org>
 <1338934303.5780.8.camel@joe2Laptop> <20120605151754.a794ac7c.akpm@linux-foundation.org>
 <1338936572.5780.29.camel@joe2Laptop> <20120605162910.caccb0d4.akpm@linux-foundation.org>
 <1338939316.11962.3.camel@joe2Laptop> <CAPXgP13J+8-dPpZkSfh9sM3xXujC2Rb9tJaOvGoEPghgdr8jiw@mail.gmail.com>
 <1338939792.11962.4.camel@joe2Laptop> <CAPXgP10DEsqtz9xbPUQ3xCwdFGTTYyTGSd7yEcU2vUr3SJ83Sw@mail.gmail.com>
 <1338940345.11962.9.camel@joe2Laptop> <20120605165808.cd255b93.akpm@linux-foundation.org>
 <1338941247.11962.16.camel@joe2Laptop> <CAPXgP12OFnh6FZO4zFGCw=Ea4U6Ne5OoCg_9BPxRX62x0EVnng@mail.gmail.com>
 <1338941971.11962.20.camel@joe2Laptop> <CAPXgP10VE2huY4gGpeFPe=YKYM+nDBfoMgpHnGmQwn0jdPxhbw@mail.gmail.com>
 <20120605173751.65a2e1ee.akpm@linux-foundation.org> <1338943205.11962.28.camel@joe2Laptop>
 <20120605174638.69bcfa31.akpm@linux-foundation.org>
From: Kay Sievers <kay@vrfy.org>
Date: Wed, 6 Jun 2012 03:10:54 +0200
Message-ID: <CAPXgP11DA2z2y4kR8C+AGtrd_-8=2Cy0jj3GX7T5JqczNke4GQ@mail.gmail.com>
Subject: Re: [PATCH 0/8] Rework KERN_<LEVEL>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 6, 2012 at 2:46 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 05 Jun 2012 17:40:05 -0700 Joe Perches <joe@perches.com> wrote:
>
>> On Tue, 2012-06-05 at 17:37 -0700, Andrew Morton wrote:
>> > On Tue, 05 Jun 2012 17:07:27 -0700 Joe Perches <joe@perches.com> wrote:
>> >
>> > > On Tue, 2012-06-05 at 16:58 -0700, Andrew Morton wrote:
>> > > >  echo "\0014Hello Joe" > /dev/kmsg
>> > >
>> > > # echo -e "\x014Hello Me" > /dev/kmsg
>> > > gives:
>> > > 12,778,4057982669;Hello Me
>> >
>> > That's changed behavior.
>>
>> Which is an improvement too.
>
> No it isn't.  It exposes internal kernel implementation details in
> random weird inexplicable ways.  It doesn't seem at all important
> though.
>
>> I very much doubt a single app will change
>> because of this.
>
> I doubt it as well.

Yeah, the value of injecting such binary data is kind of questionable. :)

Joe, maybe you can change printk_emit() to skip the prefix
detection/stripping if a prefix is already passed to the function?

Kay
