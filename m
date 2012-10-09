Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63859 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883Ab2JISV7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 14:21:59 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so2832292bkc.19
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2012 11:21:58 -0700 (PDT)
Message-ID: <50746B51.9050800@gmail.com>
Date: Tue, 09 Oct 2012 20:22:09 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: Bart Noordervliet <bart@noordervliet.net>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>
Subject: Re: [PATCH][BTRFS-PROGS][V1] btrfs filesystem df
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it> <20121003115615.GB25498@carfax.org.uk> <CAGy7Uti=kJKQ=Su1NqjOanQ+QCgsac=Au4HxibXgaa6j+as8NQ@mail.gmail.com> <CAJHuE_BCt=tXuD7mjLh_JTe+FBq=n=7tEU+3X16tUpqcsw46uA@mail.gmail.com> <CAGy7UthpCQhXVsVKqrdqgnN3vYrRNHnuE79KF79CqKsmGZM-Ag@mail.gmail.com>
In-Reply-To: <CAGy7UthpCQhXVsVKqrdqgnN3vYrRNHnuE79KF79CqKsmGZM-Ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/09/2012 02:51 PM, Bart Noordervliet wrote:
> On Tue, Oct 9, 2012 at 1:38 PM, Goffredo Baroncelli<kreijack@gmail.com>  wrote:
>> Hi Bart,
>>
>> I replayed in another email to Hugo about that. Basically I am not contrary
>> to the change, only it is unrelated to my patches. In may patches I use the
>> function pretty_sizes() which adds the suffix KB, MB, and this function was
>> here from 2008....
>
> What we could do is change all callers to use pretty_sizes_r(), which
> most already do. We could then add a mode flag for SI units, say
> DF_HUMAN_SI_UNIT. I would then propose that we enable it by default,
> like the human-readable mode itself, and create an option to disable
> it.
>
> I like options a lot, but I like sensible defaults as well. We're
> hoping btrfs will be the next major filesystem for linux. If we
> succeed, it will have a long lifespan and be used on petabyte and
> maybe exabyte storage systems. If we keep showing binary bytes, the
> discrepancy between what the drive's box says and what 'df' says will
> become ever larger.

Pay attention to the fact that the hard-disk manufacturers use the SI 
units, but all the OS works in IEC (KiB, MiB...) units. E.g. btrfs 
allocates chunk in unit of 256MB; the chunks are divided in pages (4KiB).
I am not fully convinced that we should use SI everywhere; may be that 
let the user to select in which unit system the result should be printed 
may be the best compromise.

> This is probably the last chance we'll get to make
> btrfs set a good example by getting rid of this outdated method of
> display.
>
> I can make the changes to btrfs-progs if you like.

If you want, free feel to do anything. Please don't ask me the 
permission because I am not the "owner" of the code :-)

My patches and the one which we are discussing are completely unrelated, 
so these could be made/updated separately.
Pay attention only to the text alignment where needed.


>
> Best regards,
>
> Bart
>

