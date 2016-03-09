Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38178 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934061AbcCIUSG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 15:18:06 -0500
Received: by mail-wm0-f41.google.com with SMTP id l68so1575533wml.1
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Mar 2016 12:18:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <pan$a0b9$20e2036$fc12847$9c0b91e0@cox.net>
References: <CAD=QJKiB9m_F+6AgmSJT_Dsd9HLBhXjEDFAcy6wLQNzO1DOkbQ@mail.gmail.com>
	<pan$54754$3acbb0c8$6074e95a$678977e7@cox.net>
	<CAD=QJKh2ugTHe7OyHniPL0dXm9wXZ3ur3-SSUTCAUWB2ZHRT9Q@mail.gmail.com>
	<pan$a0b9$20e2036$fc12847$9c0b91e0@cox.net>
Date: Wed, 9 Mar 2016 15:18:03 -0500
Message-ID: <CAD=QJKi95sM6s7vJrZFhf9kz=zGZPD7dkfNiX08iqjG8erdXZw@mail.gmail.com>
Subject: Re: incomplete conversion to RAID1?
From: Nicholas D Steeves <nsteeves@gmail.com>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4 March 2016 at 07:55, Duncan <1i5t5.duncan@cox.net> wrote:
> Nicholas D Steeves posted on Thu, 03 Mar 2016 16:21:53 -0500 as excerpted:
>
>>> Of course either way assumes you don't run into some bug that will
>>> prevent removal of that chunk, perhaps exactly the same one that kept
>>> it from being removed during the normal raid1 conversion.  If that
>>> happens,
>>> the devs may well be interested in tracking it down, as I'm not aware
>>> of anything similar being posted to the list.
>>
>> I've made up-to-date backups of this volume.  Is one of these two
>> methods more likely to trigger a potential bug?  Also, this potential
>> bug, if it's not just cosmetic wouldn't silently corrupt something in my
>> pool, right?  It's when things won't fail loudly and immediately that
>> concerns me, but if that's not an issue then I'd prefer to try to gather
>> potentially useful data.
>
> I don't actually expect a bug.


I used btrfs balance start -dprofiles=single, because you mentioned
you usually use btrfs balance start -dusage=0, in the hopes that I
might be able to find a useful bug.  Nope!  100% trouble free, and
very fast.

Thank you,
Nicholas
