Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from linux-libre.fsfla.org ([208.118.235.54]:37007 "EHLO
	linux-libre.fsfla.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971Ab3JVTZH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 15:25:07 -0400
From: Alexandre Oliva <oliva@gnu.org>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs raid5
References: <0833228b-7a17-49f8-836a-2565a6b9af0c@aliyun.com>
	<pan$59a02$8231ca78$f5d54bfb$30812437@cox.net>
	<or7gd59qcf.fsf@livre.home> <5266B87D.9080202@swiftspirit.co.za>
Date: Tue, 22 Oct 2013 17:24:37 -0200
In-Reply-To: <5266B87D.9080202@swiftspirit.co.za> (Brendan Hide's message of
	"Tue, 22 Oct 2013 19:40:13 +0200")
Message-ID: <ory55l85xm.fsf@livre.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Oct 22, 2013, Brendan Hide <brendan@swiftspirit.co.za> wrote:

> On 2013/10/22 07:18 PM, Alexandre Oliva wrote:
>> ... and
>> it is surely an improvement over the current state of raid56 in btrfs,
>> so it might be a good idea to put it in.
> I suspect the issue is that, while it sortof works, we don't really
> want to push people to use it half-baked.

I don't think the current state of the implementation upstream is
compatible with that statement ;-)

One can create and run a glorified raid0 that computes and updates
parity blocks it won't use for anything, while the name gives the
illusion of a more reliable filesystem than it actually is, and it will
freeze when encountering any of the failures the name suggests it would
protect from.

If we didn't have any raid56 support at all, or if it was configured
separately and disabled by default, I'd concur with your statement.  But
as things stand, any improvement to the raid56 implementation that
brings at least some of the safety net raid56 are meant to provide makes
things better, without giving users an idea that the implementation is
any more full-featured than it currently is.

> Maybe it would be nice to have some half-baked code *anyway*,
> even if Chris doesn't put it in his pull requests juuust yet. ;)

Why, sure, that's why I posted the patch; even if it didn't make it to
the repository, others might find it useful ;-)

>> So far, I've put more than
>> 1TB of data on that failing disk with 16 partitions on raid6, and
>> somehow I got all the data back successfully: every file passed an
>> md5sum check, in spite of tons of I/O errors in the process.

> Is this all on a single disk? If so it must be seeking like mad! haha

Yeah.  It probably is, but the access pattern for most of the time is
mostly random access to smallish files, so that won't be a problem.  I
considered doing raid1 on the data, to get some more reliability out of
the broken disk, but then I recalled there was this raid56
implementation that, in raid6, would theoretically bring about
additional reliability and be far more space efficient, so I decided to
give it a try.  Only after I'd put in most of the data did the errors
start popping out.  Then I decided to try and fix them instead of
moving data out.  it was some happy hacking ;-)

-- 
Alexandre Oliva, freedom fighter    http://FSFLA.org/~lxoliva/
You must be the change you wish to see in the world. -- Gandhi
Be Free! -- http://FSFLA.org/   FSF Latin America board member
Free Software Evangelist      Red Hat Brazil Compiler Engineer
