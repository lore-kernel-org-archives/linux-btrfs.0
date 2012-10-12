Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:50724 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab2JLJmh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Oct 2012 05:42:37 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH][BTRFS-PROGS][V1] btrfs filesystem df
Date: Fri, 12 Oct 2012 11:42:32 +0200
Cc: Goffredo Baroncelli <kreijack@gmail.com>,
        Bart Noordervliet <bart@noordervliet.net>,
        Hugo Mills <hugo@carfax.org.uk>
References: <1349264596-9383-1-git-send-email-kreijack@inwind.it> <CAGy7UthpCQhXVsVKqrdqgnN3vYrRNHnuE79KF79CqKsmGZM-Ag@mail.gmail.com> <50746B51.9050800@gmail.com> (sfid-20121009_214821_138744_69262FE6)
In-Reply-To: <50746B51.9050800@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201210121142.32974.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Goffredo, Bart, Hugo,

Am Dienstag, 9. Oktober 2012 schrieb Goffredo Baroncelli:
> On 10/09/2012 02:51 PM, Bart Noordervliet wrote:
> > On Tue, Oct 9, 2012 at 1:38 PM, Goffredo 
Baroncelli<kreijack@gmail.com>  wrote:
> >> Hi Bart,
> >> 
> >> I replayed in another email to Hugo about that. Basically I am not
> >> contrary to the change, only it is unrelated to my patches. In may
> >> patches I use the function pretty_sizes() which adds the suffix KB,
> >> MB, and this function was here from 2008....
> > 
> > What we could do is change all callers to use pretty_sizes_r(), which
> > most already do. We could then add a mode flag for SI units, say
> > DF_HUMAN_SI_UNIT. I would then propose that we enable it by default,
> > like the human-readable mode itself, and create an option to disable
> > it.
> > 
> > I like options a lot, but I like sensible defaults as well. We're
> > hoping btrfs will be the next major filesystem for linux. If we
> > succeed, it will have a long lifespan and be used on petabyte and
> > maybe exabyte storage systems. If we keep showing binary bytes, the
> > discrepancy between what the drive's box says and what 'df' says will
> > become ever larger.
> 
> Pay attention to the fact that the hard-disk manufacturers use the SI 
> units, but all the OS works in IEC (KiB, MiB...) units. E.g. btrfs 
> allocates chunk in unit of 256MB; the chunks are divided in pages
> (4KiB). I am not fully convinced that we should use SI everywhere; may
> be that let the user to select in which unit system the result should
> be printed may be the best compromise.

I second this.

df -h is binary by default, du -h too. There is an option to change to 
power to ten (--si).

LVM commands are binary by default as well.

KDE applications like Dolphin show KiB, MiB, GiB since quite some time. 
For file sizes and if enabled for amount of free space as well.

Only fdisk / cfdisk / parted are using power of ten, but they are rarely 
used.


If now btrfs filesystem df shows power of ten by default, a user could be 
surprised why a 100 MiB file does not fit on a drive with 103 MB free.


So I do not see much sense in using power of ten in just one place. If 
changing to power of ten by default, I think its good to do it everywhere. 
And that would require some kind of coordinated effort. And it would break 
scripts relying on binary output of df -h and du -h. I think its not wise 
of scripts to do that, heck I am quite skeptical of parsing command output 
thats formatted for the user at all, but…

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
