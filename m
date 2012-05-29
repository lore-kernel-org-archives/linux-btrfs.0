Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48664 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2E2XT7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 May 2012 19:19:59 -0400
Received: by yenm10 with SMTP id m10so2584384yen.19
        for <linux-btrfs@vger.kernel.org>; Tue, 29 May 2012 16:19:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4FC55846.1060407@gmail.com>
References: <4FC54A5D.8000600@gmail.com>
	<4FC55846.1060407@gmail.com>
Date: Tue, 29 May 2012 17:19:59 -0600
Message-ID: <CAE5mzvi_eGGL4aPTx3JAzK1F2iXGxf7x+RoZOiEqSAueQ16_Mw@mail.gmail.com>
Subject: Re: Help with recover data
From: cwillu <cwillu@cwillu.com>
To: Felix Blanke <felixblanke@gmail.com>
Cc: Maxim Mikheev <mikhmv@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 29, 2012 at 5:14 PM, Felix Blanke <felixblanke@gmail.com> wrote:
>
>
> On 5/30/12 12:14 AM, Maxim Mikheev wrote:
>>
>> Hi Everyone,
>>
>> I recently decided to use btrfs. It works perfectly for a week even
>> under heavy load. Yesterday I destroyed backups as cannot afford to have
>> ~10TB in backups. I decided to switch on Btrfs because it was announced
>> that it stable already
>> I need to recover ~5TB data, this data is important and I do not have
>> backups....
>>
>
> Just out of curiosity: Who announced that BTRFS is stable already?! The
> kernel says something different and there is still no 100% working fsck for
> btrfs. Imho it is far away from being stable :)
>
> And btw: Even it would be stable, allways keep backups for important data
> ffs! I don't understand why there are still technical experienced people who
> don't do backups :/ Imho if you don't do backups from a portion of data they
> are considered not to be important.

Some distros do offer support, but that's usually in the sense of "if
you have a support contract (and are on qualified hardware and using
it in a supported configuration), we'll help you fix what breaks (and
we're confident we can)", rather than a claim that things will never
break.

I expect (but haven't actually checked recently) that such distros
actively backport btrfs fixes to their supported kernels (btrfs in
Distro X's 3.2 kernel may have fixes that Distro Y's 3.2 kernel does
not, etc), which can lead to unfortunate misunderstandings; we don't
have enough information yet to determine whether that's the case here
though.
