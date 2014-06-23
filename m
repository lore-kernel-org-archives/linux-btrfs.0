Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:58538 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756423AbaFWRjY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 13:39:24 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <alpine.LFD.2.00.1406231606570.2169@localhost.localdomain>
References: <1403519280-24216-1-git-send-email-fdmanana@gmail.com>
	<alpine.LFD.2.00.1406231413400.2169@localhost.localdomain>
	<alpine.LFD.2.00.1406231606570.2169@localhost.localdomain>
Date: Mon, 23 Jun 2014 18:39:22 +0100
Message-ID: <CAL3q7H4ZH1Vq0zFyfMmopBaLF998yeqeVJPME=KD48AzYc0z5Q@mail.gmail.com>
Subject: Re: [PATCH] generic/017: skip invalid block sizes for btrfs
From: Filipe David Manana <fdmanana@gmail.com>
To: =?UTF-8?B?THVrw6HFoSBDemVybmVy?= <lczerner@redhat.com>
Cc: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 23, 2014 at 3:09 PM, Lukáš Czerner <lczerner@redhat.com> wrote:
> On Mon, 23 Jun 2014, Lukáš Czerner wrote:
>
>> Date: Mon, 23 Jun 2014 14:35:50 +0200 (CEST)
>> From: Lukáš Czerner <lczerner@redhat.com>
>> To: Filipe David Borba Manana <fdmanana@gmail.com>
>> Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
>> Subject: Re: [PATCH] generic/017: skip invalid block sizes for btrfs
>>
>> On Mon, 23 Jun 2014, Filipe David Borba Manana wrote:
>>
>> > Date: Mon, 23 Jun 2014 11:28:00 +0100
>> > From: Filipe David Borba Manana <fdmanana@gmail.com>
>> > To: fstests@vger.kernel.org
>> > Cc: linux-btrfs@vger.kernel.org,
>> >     Filipe David Borba Manana <fdmanana@gmail.com>
>> > Subject: [PATCH] generic/017: skip invalid block sizes for btrfs
>> >
>> > In btrfs the block size (called sector size in btrfs) can not be
>> > smaller then the page size. Therefore skip block sizes smaller
>> > then page size if the fs is btrfs, so that the test can succeed
>> > on btrfs (testing only with block sizes of 4kb on systems with a
>> > page size of 4Kb).
>>
>> The test itself is wrong, it's trying to do _scratch_mkfs with
>> different block size, but the block size might already be specified
>> by the user (in fact it should be user responsibility to test
>> different block sizes). In the case that mkfs can not handle
>> multiple of the same option like mkfs.xfs for example it will fail,
>> but the test will go on with the original file system.
>>
>> The test needs to be fixed to just test the file system with options
>> specified by the user. Also we should change _scratch_mkfs() to fail
>> the test if the mkfs failed (no one is actually testing mkfs_status
>> variable anyway.
>
> Correction, _scratch_mkfs_xfs() is actually testing mkfs_status and
> will attempt to re-run mkfs only with provided options if it failed
> before. But my point remains the same, block size to test should be
> in users hands and we should run all tests with different block
> sizes, if supported.

Ok, so in other words, get rid of the block size loop and no more
specific mkfs calls for each fs type?

Thanks Lukas

>
> Thanks!
> -Lukas
>
>>
>> Once we do that this patch will no longer be needed.
>>
>> Thanks!
>> -Lukas
>>
>> >
>> > Signed-off-by: Filipe David Borba Manana <fdmanana@gmail.com>
>> > ---
>> >  tests/generic/017 | 8 ++++++++
>> >  1 file changed, 8 insertions(+)
>> >
>> > diff --git a/tests/generic/017 b/tests/generic/017
>> > index 13b7254..6495be5 100755
>> > --- a/tests/generic/017
>> > +++ b/tests/generic/017
>> > @@ -51,6 +51,14 @@ BLOCKS=10240
>> >
>> >  for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
>> >
>> > +   # btrfs doesn't support block size smaller then page size
>> > +   if [ "$FSTYP" == "btrfs" ]; then
>> > +           if (( $BSIZE < `getconf PAGE_SIZE` )); then
>> > +                   echo "80"
>> > +                   continue
>> > +           fi
>> > +   fi
>> > +
>> >     length=$(($BLOCKS * $BSIZE))
>> >     case $FSTYP in
>> >     xfs)
>> >
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
