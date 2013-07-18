Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:61960 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757741Ab3GROTQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jul 2013 10:19:16 -0400
Received: by mail-we0-f173.google.com with SMTP id x54so2992861wes.32
        for <linux-btrfs@vger.kernel.org>; Thu, 18 Jul 2013 07:19:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$8addd$a853ed60$657c1f02$89661ea8@cox.net>
References: <pan$8addd$a853ed60$657c1f02$89661ea8@cox.net>
Date: Thu, 18 Jul 2013 10:19:15 -0400
Message-ID: <CAPs0Bijykq=HQAz3fnmh053a7iqsC93cbKGjXc9dP4-Z-V3Tiw@mail.gmail.com>
Subject: Re: bug: corrupt filesystem, cannot delete tmp files created just
 before crash.
From: Sandy McArthur <sandymac@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was able to recover the filesystem using the btrfsck from git (Btrfs
v0.20-rc1-358-g194aa4a) .

I encourage btrfsck to output a line similar to "Errors found. Run
again with --repair to attempt repairs." when errors are found.

>From using other fsck tools, I expected repairs to be attempted unless
I specified for no changes to be attempted. This would have saved me
time and the emotional grief of my perceiving that my problems were
persisting a btrfsck.


On Wed, Jul 17, 2013 at 7:38 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> Sandy McArthur posted on Wed, 17 Jul 2013 10:06:05 -0400 as excerpted:
>
>> have a btrfs filesystem that is corrupt so that I cannot remove a few
>> files. Attempting to delete these temp files from before a crash leaves
>> the filesystem read-only and sends a trace to the syslog. Assistance
>> correcting this issue is most appreciated.
>>
>> I have two disks /dev/sd{b,c}1 to make up this filesystem.
>> I've updated to the latest btrfs-tools and kernel packages available.
>> The crash happened with kernel 3.8.13-gentoo.
>>
>> # btrfs version Btrfs v0.20-rc1
>> # [uname -r] 3.10.1-gentoo
>
> Hi fellow gentooer. =:^)  I'm just a user too so won't attempt a
> technical answer.  However...
>
> I see you've tried the latest packages for both kernel and btrfs-tools.
> That's good as otherwise that's one of the the first suggestion you'd
> get.  However you don't mention the btrfs wiki, nor do you mention trying
> what it suggests in such cases, so I'll assume you're not familiar with
> it.  (Additionally, being a wiki and btrfs still being under development,
> it's worth checking back every couple months or so, and possibly using
> the wiki history function to see what has changed on your pages of
> interest since your last visit.)
>
> Main page (for bookmarking):
>
> https://btrfs.wiki.kernel.org/index.php/Main_Page
>
> Of course right at the top there it mentions (in bold) that btrfs is
> under heavy development and to run the latest, which you're basically
> doing, altho you apparently haven't tried the latest kernel rc or the
> btrfs-tools git build (which being a gentooer, I know are available, but
> masked by default).  If the following suggestion doesn't help, you might
> try them, as fixes really are going in all the time.
>
> Meanwhile, I recommend reading up on the documentation section of the
> wiki.  In particular, altho with the corruption it may not help in your
> case, pay attention to the no-space sections of the FAQ and Problem FAQ
> pages.  Even more in particular, when there's space problems it
> recommends attempting to clobber/truncate a file in place, the idea being
> to free up space without having to allocate additional metadata space to
> do it.  Again, with corruption it may not help, but it's worth a try.
>
> echo > /path/to/file
>
> Of course, even more with a development filesystem than ordinarily, you
> should have good backups, so you shouldn't need to worry too much about
> finding clobber candidates since you can recover most files from backup
> in any case.
>
> If the echo/clobber doesn't work, try again after mounting with the
> nodatacow option.  But read the wiki for the details.
>
> There's also mount options such as recovery (and skip-balance if you have
> an aborted balance it'd otherwise be trying to restart), that you can
> try.  Of course if you have the space to do so, it might be worth dd-ing
> the filesystem elsewhere as a backup image, in case you screw things up
> worse while experimenting.
>
> Meanwhile, based on my interested-admin most definitely NOT kernel-dev
> technical level following of this list at least, there /have/ been recent
> no-space, extents maintenance and other cleanups in the really-latest
> code (3.11-rc1+ kernel and live-git btrfs-tools, and there may be further
> patches posted to the list that haven't actually been committed yet),
> that may well help in your case.  I'm not technically qualified to match
> backtraces against commits/patches and identify a solid match, but it's
> definitely worth a try.
>
> Finally, as background once you're out of the tight spot, since you're
> running a multi-device filesystem, you're likely to find the discussion
> of that on the multiple devices, sysadmin guide, and use cases pages
> useful.  FWIW, here I'm running most of my btrfs filesystems in dual-
> device raid1 (both data/metadata) mode, to take advantage of the
> checksumming and extra copy to lookup in case of checksum error, that
> btrfs offers, in addition to the device-loss scenario that raid1 helps
> protect against.
>
> --
> Duncan - List replies preferred.   No HTML msgs.
> "Every nonfree program has a lord, a master --
> and if you use the program, he is your master."  Richard Stallman
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Sandy McArthur

"He who dares not offend cannot be honest."
- Thomas Paine
