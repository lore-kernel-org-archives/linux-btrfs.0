Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:36183 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195AbcCOWIn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 18:08:43 -0400
Received: by mail-wm0-f41.google.com with SMTP id l124so27622415wmf.1
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2016 15:08:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$df368$11da4cf4$ea45e87d$e6f8d7f4@cox.net>
References: <1455774178-3595-1-git-send-email-quwenruo@cn.fujitsu.com>
	<1455774178-3595-2-git-send-email-quwenruo@cn.fujitsu.com>
	<87io0vjq9x.fsf@notabene.neil.brown.name>
	<56E0C668.4020406@cn.fujitsu.com>
	<20160311114305.GQ18908@twin.jikos.cz>
	<56E3D070.3020005@gmx.com>
	<56E4F7AB.4010608@cn.fujitsu.com>
	<87egbeipdp.fsf@notabene.neil.brown.name>
	<pan$df368$11da4cf4$ea45e87d$e6f8d7f4@cox.net>
Date: Tue, 15 Mar 2016 18:08:41 -0400
Message-ID: <CAD=QJKhbM2OJrrXo27f+Y1g+MLf7p_ZyGtMnnQaHQ=4yi_O-kg@mail.gmail.com>
Subject: Re: [PATCH v7 01/20] btrfs: dedup: Introduce dedup framework and its header
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13 March 2016 at 12:55, Duncan <1i5t5.duncan@cox.net> wrote:
> NeilBrown posted on Sun, 13 Mar 2016 22:33:22 +1100 as excerpted:
>
>> On Sun, Mar 13 2016, Qu Wenruo wrote:
>>
>>> BTW, I am always interested in, why de-duplication can be shorted as
>>> 'dedupe'.
>
>>> I didn't see any 'e' in the whole word "DUPlication".
>>> Or it's an abbreviation of "DUPlicatE" instead of "DUPlication"?
>>
>> The "u" in "duplicate" is pronounced as a long vowel sound, almost like
>> d-you-plicate.
>
>> To make a vowel long you can add an 'e' at the end of a word.
>
>> by analogy, "dupe" has a long "u" and so sounds like the first syllable
>> of "duplicate".
>
> As a native (USian but with some years growing up in the then recently
> independent former Crown colony of Kenya, influencing my personal
> preferences) English speaker, while what Neil says about short "u" vs.
> long "u" is correct, I agree with Qu that the "e" in dupe doesn't make so
> much sense, and would, other things being equal, vastly prefer dedup to
> dedupe, myself.
>
> However, there's some value in consistency, and given the previous dedupe
> precedent in-kernel, sticking to that for consistency reasons makes sense.
>
> But were this debate to have been about the original usage, I'd have
> definitely favored dedup all the way, as not withstanding Neil's argument
> above, adding the "e" makes little sense to me either.  So only because
> it's already in use in kernel code, but if this /were/ the original
> kernel code...
>
> So I definitely understand your confusion, Qu, and have the same personal
> preference even as a native English speaker. =:^)

I'm not sure to what degree the following is a relevant concern, and
I'm guessing it's not, other than for laughs, but to me "dedupe" reads
as "de-dupe" or "undupe".  While it functions as the inverse of the
verb "to dupe", I don't think one can "be unduped" or "be unfooled".
What is that old aphorism?  "Once duped twice shy"? ;-)

Honestly I'm surprised that a verb-form of "tuple" hasn't yet emerged,
because if it had we might be saying "detup" instead of "dedup".

Best regards,
Nicholas
