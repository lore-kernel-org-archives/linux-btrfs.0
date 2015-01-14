Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:47667 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750995AbbANAjI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 19:39:08 -0500
From: Josef Bacik <jbacik@fb.com>
To: Merlijn Wajer <merlijn@wizzup.org>
CC: David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Revert "btrfs-progs: disable backtrace and define
 __always_inline"
Date: Wed, 14 Jan 2015 00:39:02 +0000
Message-ID: <q9fvbbb948egl9yswpp15tpe.1421195940816@email.android.com>
References: <1421187619-24936-1-git-send-email-jbacik@fb.com>
 <20150114001341.GP3685@twin.jikos.cz>,<54B5B5FA.20904@wizzup.org>
 <o7p8o4w432kx17p86ckfs9b3.1421195194593@email.android.com>,<alpine.LNX.2.00.1501140126290.19863@chrometwo.fritz.box>
In-Reply-To: <alpine.LNX.2.00.1501140126290.19863@chrometwo.fritz.box>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yeah just make sure we still get a backtrace on glibc.  Thanks,

Josef

Merlijn Wajer <merlijn@wizzup.org> wrote:


Hi,

On Wed, 14 Jan 2015, Josef Bacik wrote:

> This only works if you include features.h and I don't know if other libcs provide that.  Thanks,

musl provides /usr/include/features.h and glibc does so as well. (Checked
on musl and glibc systems) Searching the web seems to suggest that uclibc
supports it as well.

Would you be in favour of including features.h and checking for __GLIBC__ ?

Regards,
Merlijn
