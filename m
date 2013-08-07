Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:39650 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654Ab3HGBVJ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 6 Aug 2013 21:21:09 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1V6sR1-0004VA-SH
	for linux-btrfs@vger.kernel.org; Wed, 07 Aug 2013 03:21:07 +0200
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Aug 2013 03:21:07 +0200
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Aug 2013 03:21:07 +0200
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: [PATCH RFC] Btrfs: add support for persistent mount options
Date: Wed, 7 Aug 2013 01:20:46 +0000 (UTC)
Message-ID: <pan$7a11c$80d8bc74$817230d3$dcd60b21@cox.net>
References: <1375813640-14063-1-git-send-email-fdmanana@gmail.com> <52015E8A
	.9000300@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Eric Sandeen posted on Tue, 06 Aug 2013 15:37:30 -0500 as excerpted:

> On 8/6/13 1:27 PM, Filipe David Borba Manana wrote:
>> This change allows for most mount options to be persisted in the
>> filesystem, and be applied when the filesystem is mounted.
>> If the same options are specified at mount time, the persisted values
>> for those options are ignored.
>> 
>> The only options not supported are: subvol, subvolid, subvolrootid,
>> device and thread_pool. This limitation is due to how this feature is
>> implemented: basically there's an optional value (of type struct
>> btrfs_dir_item) in the tree of tree roots used to store the list of
>> options in the same format as they are passed to btrfs_mount().
>> This means any mount option that takes effect before the tree of tree
>> roots is setup is not supported.
>> 
>> To set these options, the user space tool btrfstune was modified to
>> persist the list of options into an unmounted filesystem's tree of tree
>> roots.
> 
> So, it does this thing, ok - but why?
> What is seen as the administrative advantage of this new mechanism?
> 
> Just to play devil's advocate, and to add a bit of history:
> 
> On any production system, the filesystems will be mounted via fstab,
> which has the advantages of being widely known, well understood, and
> 100% expected - as well as being transparent, unsurprising, and
> seamless.
> 
> For history: ext4 did this too.  And now it's in a situation where it's
> got mount options coming at it from both the superblock and from the
> commandline (or fstab), and sometimes they conflict; it also tries to
> report mount options in /proc/mounts, but has grown hairy code to decide
> which ones to print and which ones to not print (if it's a "default"
> option, don't print it in /proc/mounts, but what's default, code-default
> or fs-default?)  And it's really kind of an ugly mess.
> 
> Further, mounting 2 filesystems w/ no options in fstab or on the
> commandline, and getting different behavior due to hidden (sorry,
> persistent) options in the fs itself is surprising, and surprise is
> rarely good.
> 
> So this patch adds 100+ lines of new code, to implement this idea, but:
> what is the advantage?  Unless there is a compelling administrative use
> case, I'd vote against it.  Lines of code that don't exist don't have
> bugs.  ;)

As an admin, there's some options I want always applied as site policy.  
Here, that includes compress=lzo, autodefrag and noatime.  And with all 
the capacities btrfs has what with raid and the like, particularly if 
someone's needing to use device= (which won't go in the persistent 
options for what should be pretty obvious reasons) a bunch of times, that 
fstab line can get quite long indeed![1]

Just like the kernel has a config option for a built-in commandline that 
takes some of the pressure off the actually passed commandline for 
options that are pretty much always going to be used so it's easier to 
administer because only the possibly dynamic options or those going 
against the builtin commandline defaults need passed, a filesystem as 
complex and multi-optioned as btrfs is, really NEEDS some way to persist 
the options that are effectively site policy default, so the admin 
doesn't have to worry about them any longer.

FWIW, I had assumed persistent mount options were planned as a given and 
simply hadn't been implemented yet.  Because to me it's a no-brainer.  
After all, people don't have to use the feature if they don't like it.  
And it sure saves a headache when what might otherwise be a dozen 
parameters passed in can be cut in half or better, leaving only the ones 
that are going to differ depending on circumstances to worry about.  I 
know that from experience with the kernel builtin commandline option!

---
[1] I ran initr*less root-on-md-raid for many years.  That involved 
passing a complicated set of md1=/dev/sda3,/dev/sdb3,/dev/sdc3,/dev/sdd3 
type options to the kernel, along with more usual options I was passing, 
and I was SO happy when the kernel got that built-in-commandline option 
and I could put the default set in there, such that I only had to worry 
about passing that parameter for the backup boot option, thus along with 
several other passed options I was able to put in the builtin, shrinking 
the actual passed kernel commandline dramatically, so only the stuff that 
wasn't the default needed passed for a particular boot option.  It would 
sure be nice to be able to do the same thing, but at the filesystem 
level, here!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

