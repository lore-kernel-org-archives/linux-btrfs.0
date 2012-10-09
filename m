Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:46726 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363Ab2JIMwP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 08:52:15 -0400
Received: by mail-we0-f174.google.com with SMTP id t9so3206319wey.19
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2012 05:52:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJHuE_BCt=tXuD7mjLh_JTe+FBq=n=7tEU+3X16tUpqcsw46uA@mail.gmail.com>
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it>
 <20121003115615.GB25498@carfax.org.uk> <CAGy7Uti=kJKQ=Su1NqjOanQ+QCgsac=Au4HxibXgaa6j+as8NQ@mail.gmail.com>
 <CAJHuE_BCt=tXuD7mjLh_JTe+FBq=n=7tEU+3X16tUpqcsw46uA@mail.gmail.com>
From: Bart Noordervliet <bart@noordervliet.net>
Date: Tue, 9 Oct 2012 14:51:53 +0200
Message-ID: <CAGy7UthpCQhXVsVKqrdqgnN3vYrRNHnuE79KF79CqKsmGZM-Ag@mail.gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS][V1] btrfs filesystem df
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Hugo Mills <hugo@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 9, 2012 at 1:38 PM, Goffredo Baroncelli <kreijack@gmail.com> wrote:
> Hi Bart,
>
> I replayed in another email to Hugo about that. Basically I am not contrary
> to the change, only it is unrelated to my patches. In may patches I use the
> function pretty_sizes() which adds the suffix KB, MB, and this function was
> here from 2008....

What we could do is change all callers to use pretty_sizes_r(), which
most already do. We could then add a mode flag for SI units, say
DF_HUMAN_SI_UNIT. I would then propose that we enable it by default,
like the human-readable mode itself, and create an option to disable
it.

I like options a lot, but I like sensible defaults as well. We're
hoping btrfs will be the next major filesystem for linux. If we
succeed, it will have a long lifespan and be used on petabyte and
maybe exabyte storage systems. If we keep showing binary bytes, the
discrepancy between what the drive's box says and what 'df' says will
become ever larger. This is probably the last chance we'll get to make
btrfs set a good example by getting rid of this outdated method of
display.

I can make the changes to btrfs-progs if you like.

Best regards,

Bart
