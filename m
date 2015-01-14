Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:60274 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751176AbbANA0k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 13 Jan 2015 19:26:40 -0500
From: Josef Bacik <jbacik@fb.com>
To: Merlijn Wajer <merlijn@wizzup.org>
CC: David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Revert "btrfs-progs: disable backtrace and define
 __always_inline"
Date: Wed, 14 Jan 2015 00:26:36 +0000
Message-ID: <o7p8o4w432kx17p86ckfs9b3.1421195194593@email.android.com>
References: <1421187619-24936-1-git-send-email-jbacik@fb.com>
 <20150114001341.GP3685@twin.jikos.cz>,<54B5B5FA.20904@wizzup.org>
In-Reply-To: <54B5B5FA.20904@wizzup.org>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This only works if you include features.h and I don't know if other libcs provide that.  Thanks,

Josef

Merlijn Wajer <merlijn@wizzup.org> wrote:


Hi,

On 14/01/15 01:13, David Sterba wrote:
> On Tue, Jan 13, 2015 at 05:20:19PM -0500, Josef Bacik wrote:
>> This reverts commit c2691f807ddd2c6b261c5707f6838a45d9275390 as it breaks
>> backtracing on actual glibc environments.
>
> This is to support musl libc. If it does not work then the test is wrong
> and should be fixed. CCed the author.

Thanks for letting me know. It unfortunately seems like I made a
mistake: it should be __GLIBC__ and not __glibc__.

Sorry about that. Would you like me to create a patch?

Regards,
Merlijn

