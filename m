Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:53462 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbaBJADD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 9 Feb 2014 19:03:03 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1WCeKz-0008Md-7x
	for linux-btrfs@vger.kernel.org; Mon, 10 Feb 2014 01:03:01 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 01:03:01 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 01:03:01 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: Provide a better free space estimate on RAID1
Date: Mon, 10 Feb 2014 00:02:38 +0000 (UTC)
Message-ID: <pan$54634$38204be5$c7d36933$70b8f264@cox.net>
References: <20140206021516.304732cd@natsu> <52F3EED4.7030603@fb.com>
	<agsfsa-mks.ln1@hurikhan77.spdns.de> <20140208173310.1f90af3b@natsu>
	<20140208114634.GH6490@carfax.org.uk> <cikisa-qf7.ln1@hurikhan77.spdns.de>
	<20140209041050.529ff6f9@natsu>
	<pan$e196e$601e36f4$65c8817c$b6141c66@cox.net>
	<20140209152000.209756de@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Roman Mamedov posted on Sun, 09 Feb 2014 15:20:00 +0600 as excerpted:

> On Sun, 9 Feb 2014 06:38:53 +0000 (UTC)
> Duncan <1i5t5.duncan@cox.net> wrote:
> 
>> RAID or multi-device filesystems aren't 1970s features and break 1970s
>> behavior and the assumptions associated with it.  If you're not
>> prepared to deal with those broken assumptions, don't.  Use mdraid or
>> dmraid or lvm or whatever to combine your multiple devices into one
>> logical devices as presented, and put your filesystem (either
>> traditional filesystem, or even btrfs using traditional single-device
>> functionality) on top of the single device the layer beneath the
>> filesystem presents.  Problem solved! =:^)
> 
> No reason BTRFS can't work well in a similar simplistic usage scenario.
> 
> You seem to insist there is no way around it being "too flexible for its
> own good", but all those advanced features absolutely don't *have* to
> get in the way of everyday usage for users who don't require them.

Not really.  I'm more insisting that I've not seen a good kernel-space 
solution to the problem yet, and believe that it's a userspace or wetware 
problem.

And I provided a userspace/wetware solution that works for me, too. =:^)

>> Meanwhile, what I've done here is use one of df's commandline options
>> to set its block size to 2 MiB, and further used bash's alias
>> functionality to setup an alias accordingly:
>> 
>> alias df='df -B2M'
>> 
>> $ df /h Filesystem     2M-blocks  Used Available Use% Mounted on
>> /dev/sda6          20480 12186      7909  61% /h

>> On btrfs such as the above I can read the 2M blocks as 1M and be happy.
>>
>> On btrfs such as my /boot, which aren't raid1 (I have two separate
>> /boots, one on each device, with grub2 configured separately for each
>> to provide a backup), or if I df my media partitions still on reiserfs
>> on the old spinning rust, I can either double the figures DF gives me,
>> or add a second -B option at the CLI, overriding the aliased option.
> 
> Congratulations, you broke your df readings on all other filesystems to
> fix them on btrfs.

No.  It clearly says 2M blocks.  Nothing's broken at all, except perhaps 
the user's wetware.

I just find it a easier to do the doubling in wetware on the occasion 
it's needed, in MiB, then halving on more frequent occasions (since all 
my core automounted filesystems that I'd normally be doing df on are 
btrfs raid1), larger KiB or byte units, and don't need to do that wetware 
halving often enough to have gone to the trouble of setting up the 
software-scripted version I propose below.

>> If I wanted something fully automated, it'd be easy enough to setup a
>> script that checked what filesystem I was df-ing, matched that against
>> a table of filesystems to preferred df block sizes, and supplied the
>> appropriate -BxX option accordingly.
> 
> I am not sure this would work well in the network share scenario
> described earlier, with clients which in the real world are largely
> Windows-based.

So patch the window-based stuff... oh, you've let them be your master (in 
the context of my sig below) and you can't...  Well, servant by choice, I 
guess...  There's freedom if you want it... which in fact you are using 
to do your kernel patches.  Try patching the MS Windows kernel and 
distributing those patches, and see how far you get! =:^(

FWIW/IMO, in the business context Ernie Ball made the right decision.  
One BSA audit was enough.  He said no more, and the company moved to free 
as in freedom software and isn't beholden to the whims of any servantware 
or the BSA auditors enforcing it, any longer. =:^)

But as I said, your systems (or your company's systems), play servant 
with them and be subject to the BSA gestapo (or the equivalent in your 
country) if you will.  No skin off my nose.  <shrug>


Meanwhile, you said it yourself, users aren't normally concerned about 
this.  And others pointed out that to the degree users /are/ concerned, 
they should be looking at their quotas, not filesystem level usage.

And admins, assuming they're proper admins, not the simple "here's my 
MCSE, I'm certified to do anything, and if I can't do it, it's not 
possible", types, should have the wetware resources to either deal with 
the problem there, or script their own solutions, offloading it from 
wetware to installation-specific userspace software scripts as necessary.


All that said, it's worth noting that there ARE already API changes 
proposed and working their way thru the pipeline, that would expose 
various bits of necessary data to userspace in a standardized API that 
filesystems other than btrfs could make use of as well, with the intent 
of then updating coreutils (the package containing df) and friends to 
allow them to make use of the information exposed by this API to improve 
their default information output and allow for additional CLI level 
options as appropriate.  Presumably other userspace apps, including the 
GUIs over time, would follow the same course.

But the key is, getting a standardized modern API ready and the data 
exposed to userspace via said API in a standardized way, so that all 
userspace apps can make use of it the same way they use the existing APIs 
to provide used/free-space data today, but updated from the 1970s style 
APIs their currently using, to this standardized more modern one, in 
ordered to provide correct and accurate information to the user, 
regardless of whether they're using legacy filesystems or something more 
modern such as btrfs.

The point being, it's early days yet, in terms of btrfs and similar 
modern multi-device flexible usage filesystems, it's basically early 
adopters having to deal with it now and /as/ early adopters, they can 
cope with it.  Meanwhile, as we know, premature optimization is the root 
of evil, so be patient, and a reasonable solution, standardized so that 
other modern filesystems can use the same APIs and expose the same sort 
of information for userspace to work out the presentation of, will 
eventually appear.

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

