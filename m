Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32951 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753887AbcE0LNg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 May 2016 07:13:36 -0400
Received: by mail-wm0-f68.google.com with SMTP id a136so13861516wme.0
        for <linux-btrfs@vger.kernel.org>; Fri, 27 May 2016 04:13:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160524105034.GO29147@twin.jikos.cz>
References: <1463707125-21899-1-git-send-email-nsteeves@gmail.com>
	<1463707125-21899-2-git-send-email-nsteeves@gmail.com>
	<CAD=QJKgZE8Dz_GgNpC5U85nd-FD5P_2k=UJwCMBhqFzL2H+DHA@mail.gmail.com>
	<20160523170123.GM29147@twin.jikos.cz>
	<CAD=QJKg-+=YXJH6koQ+f-xRWfHp0N9B3m_ObxrtmNhKSfer_Yg@mail.gmail.com>
	<20160524105034.GO29147@twin.jikos.cz>
Date: Fri, 27 May 2016 07:13:35 -0400
Message-ID: <CAD=QJKhw35h=mC0m02Bx9+q=VJMrSem1s-Y7gB4zEtFbdfQ+Vg@mail.gmail.com>
Subject: Re: [1/1 v2] String and comment review: Fix typos; fix a couple of
 mandatory grammatical issues for clarity.
From: Nicholas D Steeves <nsteeves@gmail.com>
To: dsterba@suse.cz, Nicholas D Steeves <nsteeves@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 24 May 2016 at 06:50, David Sterba <dsterba@suse.cz> wrote:
> On Mon, May 23, 2016 at 02:26:46PM -0400, Nicholas D Steeves wrote:
>> On 23 May 2016 at 13:01, David Sterba <dsterba@suse.cz> wrote:
>> > On Thu, May 19, 2016 at 09:30:49PM -0400, Nicholas D Steeves wrote:
>> >> Sorry for the noise.  Please disregard my v1 patch and subsequent
>> >> emails.  This patch is for upstream linux-next.  From now on I think
>> >> that's what I'm going to work from, to keep things simple, because it
>> >> seems I'm still inept with git.
>> >
>> > The patch applies cleanly on top of the current branch that's going to
>> > Linus tree, so I'll queue it for the next pull request. All your inline
>> > notices were addressed. Thanks.
>>
>> You're welcome, and thank you for the assistance.  I don't want to
>> annoy everyone with a regular stream of these patches, so what do you
>> think of the the following?:  I'll submit a patch for user-facing
>> typos in btrfs-progs when I find one,
>
> Sending typo fixes for all user visible text is OK and welcome anytime.
>
>> if I find any, and a strings &
>> comments review for both -progs and kernel twice a year, where one
>> review is part of preparing for an LTS kernel.
>
> Typos in comments can be done once in a year I think.

Thank you for the clarification.  When would be the best time?  While
preparing for an LTS kernel, or a certain amount of time before one?
Would you like me to skip 4.10 this year and stick to doing it in the
month of May?

Best regards,
Nicholas
