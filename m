Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42499 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753985AbaKRMNv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Nov 2014 07:13:51 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XqhfJ-0001di-OF
	for linux-btrfs@vger.kernel.org; Tue, 18 Nov 2014 13:13:49 +0100
Received: from ip68-231-22-224.ph.ph.cox.net ([68.231.22.224])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 13:13:49 +0100
Received: from 1i5t5.duncan by ip68-231-22-224.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Nov 2014 13:13:49 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: BTRFS messes up snapshot LV with origin
Date: Tue, 18 Nov 2014 12:13:36 +0000 (UTC)
Message-ID: <pan$a406a$db080830$3eeeaf87$f48bd693@cox.net>
References: <CAE8gLhnLUBJmN=3n1SVTc3y0zbBAxSBXtMxe7rhANtwC+3dCow@mail.gmail.com>
	<pan$f02e0$7a5e2052$d1925753$4ad202f9@cox.net>
	<54699CC7.1050909@swiftspirit.co.za>
	<988DFC86-0C84-4735-AF3D-02CD394D5FEA@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: bug-grub@gnu.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Chris Murphy posted on Mon, 17 Nov 2014 23:21:57 -0700 as excerpted:

> I think we’re well past the expiration date on grub.cfg, a line should
> be drawn in the sand to deprecate routine use of os-prober +
> grub-mkconfig,
> and move to drop-in scripts by whatever the distro presumes will be
> responsible for managing what “tree” will be booted or will be offered
> as a boot option, all GRUB needs to learn is how to use that drop in
> script file format.
> 
> Ergo just because I’ve snapshot my root does not mean grub-mkconfig
> should be creating boot entries for it. But whatever usespace tool I’m
> using to do those snapshots (ostree, snapper, whatever the GNOME folks
> might come up with) should be the thing that creates the boot entry
> script; or as simple as this 2-4 line script should be, even hand done
> by a user, unlike the current grub.cfg file format.

FWIW, I hand-edit my grub.cfg here, grub-probe was taking /forever/ on my 
system back when I upgraded to grub2, and the "direct drive" 
configuration of direct grub.cfg editing was /far/ more flexible, or at 
least /far/ easier to learn how to do what I wanted to do than to figure 
out how to do it thru the translation layer, in any case.

The configuration is advanced enough it has individual choices to set 
standard init and init=/bin/bash, current/fallback/stable kernels, 
current/backup/second-backup roots, etc, plus a choice to interactively 
type in additional kernel commandline options, loading those choices into 
grub variables as I change them, then another choice to boot using the 
loaded variables to select the kernel and setup the kernel commandline.  
The initial grub.cfg has the default boot option, plus others that load 
either a troubleshooting menu or the backups choices menu, from separate 
included config files, as necessary.  Just /thinking/ about trying to do 
that via the cumbersome translation layer gives me a headache, and since 
I had to learn the grub scripting layer language to set it up anyway, I 
might as well just write and troubleshoot it in that directly rather than 
trying to figure out how to get the translation layer to write it, and 
then have to troubleshoot BOTH the translation layer and the lower level 
script.

Then I deleted grub-probe and grub-mkconfig so they couldn't be run 
accidentally with unconfigured/default translation-level options to undo 
all my hard work, and set a mask on them so updating the package wouldn't 
reinstall them.

So deprecate/kill os-prober and grub-mkconfig if you want, but grub.cfg 
needs to stay working!

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

