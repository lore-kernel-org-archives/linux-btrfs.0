Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:35418 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbcFZTyu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Jun 2016 15:54:50 -0400
Received: by mail-oi0-f45.google.com with SMTP id r2so176876757oih.2
        for <linux-btrfs@vger.kernel.org>; Sun, 26 Jun 2016 12:54:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1466946315.4049.19.camel@sapo.pt>
References: <loom.20160623T205347-371@post.gmane.org> <CAJCQCtRO+FYrsfHF_ARSnPfoS7uzvLR4hB1V-TJ_YN4NcA6srw@mail.gmail.com>
 <5356822.A3RRKHDHNy@linux-omuo> <CAJCQCtQ-xYrERT5R4gSC1C7OkoeP2LeS9W9UL5VY5SmDBXk71w@mail.gmail.com>
 <20160625010610.Horde.tUycS31CmgVWfy3CPu7qJCD@mail.sapo.pt>
 <CAJCQCtSGZO8JVXqVOwifT84KTLCkciux+Y6A_na4AA-PxPjjbw@mail.gmail.com>
 <20160625211024.Horde.pL6RMZNJL6tnjtpglBZjDaB@mail.sapo.pt>
 <CAJCQCtQ+q90r=Q38mtVKoBeAmXmPJPP2cp=dfLj3kBiEv66bzA@mail.gmail.com> <1466946315.4049.19.camel@sapo.pt>
From: Chris Murphy <lists@colorremedies.com>
Date: Sun, 26 Jun 2016 13:54:48 -0600
Message-ID: <CAJCQCtSaMTA4a8+jGO8TXEQCQi7Yi2pS-S2qPNKt8q1eZSkULA@mail.gmail.com>
Subject: Re: Bad hard drive - checksum verify failure forces readonly mount
To: Vasco Almeida <vascomalmeida@sapo.pt>
Cc: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jun 26, 2016 at 7:05 AM, Vasco Almeida <vascomalmeida@sapo.pt> wrote:
> A Sáb, 25-06-2016 às 14:54 -0600, Chris Murphy escreveu:
>> On Sat, Jun 25, 2016 at 2:10 PM, Vasco Almeida <vascomalmeida@sapo.pt
>> > wrote:
>> > Citando Chris Murphy <lists@colorremedies.com>:
>> > > 3. btrfs-image so that devs can see what's causing the problem
>> > > that
>> > > the current code isn't handling well enough.
>> >
>> >
>> > btrfs-image does not create dump image:
>> >
>> > # btrfs-image /dev/mapper/vg_pupu-lv_opensuse_root
>> > btrfs-lv_opensuse_root.image
>> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
>> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
>> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
>> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
>> > Csum didn't match
>> > Error reading metadata block
>> > Error adding block -5
>> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
>> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
>> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
>> > checksum verify failed on 437944320 found 8BF8C752 wanted 39F456C8
>> > Csum didn't match
>> > Error reading metadata block
>> > Error flushing pending -5
>> > create failed (Success)
>> > # echo $?
>> > 1
>>
>> Well it's pretty strange to have DUP metadata and for the checksum
>> verify to fail on both copies. I don't have much optimism that brfsck
>> repair can fix it either. But still it's worth a shot since there's
>> not much else to go on.
>
> I have tried "btrfs check --repair /device" but that seems do not do
> any good.
> http://paste.fedoraproject.org/384960/66945936/

It did fix things, in particular with the snapshot that was having
problems being dropped. But it's not enough it seems to prevent it
from going read only.

There's more than one bug here, you might see if the repair was good
enough that it's possible to use brtfs-image now. If not, use
btrfs-debug-tree <dev> > file.txt and post that file somewhere. This
does expose file names. Maybe that'll shed some light on the problem.
But also worth filing a bug at bugzilla.kernel.org with this debug
tree referenced (probably too big to attach), maybe a dev will be able
to look at it and improve things so they don't fail.


> What else can I do or I must rebuild the file system?

Well, it's a long shot but you could try using --repair --init-csum
which will create a new csum tree. But that applies to data, if the
problem with it going read only is due to metadata corruption this
won't help. And then last you could try --init-extent-tree. Thing I
can't answer is which order to do it in.

In any case there will be files that you shouldn't trust after csum
has been recreated, anything corrupt will now have a new csum, so you
can get silent data corruption. It's better to just blow away this
file system and make a new one and reinstall the OS. But if you're
feeling brave, you can try one or both of those additional options and
see if they can help.


-- 
Chris Murphy
