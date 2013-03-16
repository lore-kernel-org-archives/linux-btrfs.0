Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ishtar.tlinx.org ([173.164.175.65]:53627 "EHLO
	Ishtar.hc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab3CPMsK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 16 Mar 2013 08:48:10 -0400
Message-ID: <5144620C.4040203@tlinx.org>
Date: Sat, 16 Mar 2013 05:14:04 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
CC: linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests: enable test 032 (mkfs overwrite) for btrfs
References: <5140A2BC.7010800@redhat.com> <51435555.2020706@sgi.com> <5143568F.5060900@redhat.com>
In-Reply-To: <5143568F.5060900@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Eric Sandeen wrote:

>>
>> It did not put mkfs.btrfs in /sbin.  This did however, validate all the error paths ;).
> Heh ;)
> Well, mixing & matching upstream installs from source w/ rpm-packaged binaries is usually asking for trouble. 
> I don't think it's a bug, just bad administrative practice ;)
----
	SuSE is moving most if not all of their boot-related binaries off of "/" and
putting
them in /usr, requiring that you either have 1 partition for / and /usr or you run
their initrd that will pre-mount /usr on "/".  Supposedly this is a requirement
of moving the the MS-compat boot architecture, "systemd" and is being done by all
the distros... (supposedly)...  At least RedHat and SuSE are going that way...

	It's great to boot up in single-user from your hard disk and be told mount
needs libs on a yet-to-be mounted partition...

;-/

	
