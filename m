Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:44271 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751447AbaICGBd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Sep 2014 02:01:33 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Large files, nodatacow and fragmentation
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CADw2B2M+WSbCyphH3Y=5w8JyMHYe7sL_MdvScy9NLPS3PbRHiQ@mail.gmail.com>
Date: Wed, 3 Sep 2014 00:01:31 -0600
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <88B7E732-0EB2-422C-B5C7-950E483C2E71@colorremedies.com>
References: <CADw2B2Neg6-iG4uwGoW6XPomY4+-1BkUTx-7zPrAZPS6R3pRYg@mail.gmail.com> <20140812011401.568c16e6@natsu> <AC90CAC7-A8F5-4C74-8295-4360A6A8FE45@colorremedies.com> <CADw2B2NnWFY=rOvArTDtnw2jkRe-HqNCcqeB0r80et60euEy3g@mail.gmail.com> <9EB33BE3-FAC0-4AE8-BB95-ABE68C578D47@colorremedies.com> <CADw2B2MGyDAvAxrZOML0kX_shdFD6QSyMV9XWxKfJAoZpLXsSQ@mail.gmail.com> <08770CD2-AA55-4BC1-B92C-E7D3360399F8@colorremedies.com> <CADw2B2NJQYn_xkrAebmdu_c-7z7yFNZ1aDFS=jYmQcHfco2d+g@mail.gmail.com> <5CE63712-2C3E-4BF3-B971-C6F17AE10E3D@colorremedies.com> <CADw2B2N4T_XWOWt++8wGhXk5WJmKgQGqhbt=m2JbQCO_ekfhxA@mail.gmail.com> <540617DE.5070605@gmail.com> <CADw2B2M+WSbCyphH3Y=5w8JyMHYe7sL_MdvScy9NLPS3PbRHiQ@mail.gmail.com>
To: "G. Richard Bellamy" <rbellamy@pteradigm.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I created two pools, one xfs one btrfs, default formatting and mount options. I then created a qcow2 file on each using virt-manager, also using default options. And default caching (whatever that is, I think it's writethrough but don't hold me to it).

I then installed Windows 7 (not concurrently) to each qcow2 file. Immediately after install, at the BIOS screen for the 1st reboot from install, the fragment count is:

btrfs:	1576
xfs:	665

After letting each of them proceed through their subsequent reboots, and hang out for ~ 1 hour while mscorsvw.exe and svchost.exe do a bunch of stuff busying up the drive and sucking CPU, I get the following counts once they went idle:

btrfs	8042
xfs	8369


As a note, there was about 20-30 minutes of idle time at which point for xfs the extent count was 2564, and within 5 minutes of svchost.exe going all chaotic the fragment count was 8369. At which point it stayed there for another 10 or so minutes, and even through a couple reboots it stayed at that point. So there are Windows 7 processes that can cause a lot of fragmentation of qcow2 files in a very short period of time. I have no idea what they're doing, but a lot of this is probably just the nature of qcow2 files.

Also, 'qemu-img create' has a relatively new option 'nocow'. If -o nocow=on then qemu-img sets xattr +C on the qcow2 file at the time of its creation. This is a btrfs only option, and is described in the man page.

Does anyone know if filefrag's physical_offset value has any correlation to disk sectors at all? Or is it just another kind of logical value? I ask because the vast majority of the extents have sequential ordering based on the reported physical_offset. It's not like the extents are being created haphazardly all over the drive. So I'm not convinced that this kind of fragmentation is really a big problem.


Chris Murphy