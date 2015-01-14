Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from nala.villavu.com ([188.165.243.101]:42484 "EHLO
	nala.villavu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbANAcc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 19:32:32 -0500
Date: Wed, 14 Jan 2015 01:31:34 +0100 (CET)
From: Merlijn Wajer <merlijn@wizzup.org>
To: Josef Bacik <jbacik@fb.com>
cc: David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Revert "btrfs-progs: disable backtrace and define
 __always_inline"
In-Reply-To: <o7p8o4w432kx17p86ckfs9b3.1421195194593@email.android.com>
Message-ID: <alpine.LNX.2.00.1501140126290.19863@chrometwo.fritz.box>
References: <1421187619-24936-1-git-send-email-jbacik@fb.com> <20150114001341.GP3685@twin.jikos.cz>,<54B5B5FA.20904@wizzup.org> <o7p8o4w432kx17p86ckfs9b3.1421195194593@email.android.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Wed, 14 Jan 2015, Josef Bacik wrote:

> This only works if you include features.h and I don't know if other libcs provide that.  Thanks,

musl provides /usr/include/features.h and glibc does so as well. (Checked
on musl and glibc systems) Searching the web seems to suggest that uclibc
supports it as well.

Would you be in favour of including features.h and checking for __GLIBC__ ?

Regards,
Merlijn
