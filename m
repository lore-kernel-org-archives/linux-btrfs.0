Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39838 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab3HTNqZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Aug 2013 09:46:25 -0400
Message-ID: <5213732F.4010900@sandeen.net>
Date: Tue, 20 Aug 2013 08:46:23 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Stefan Behrens <sbehrens@giantdisaster.de>
CC: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: add regression test for kernel bz 60673 V2
References: <1376945597-2202-1-git-send-email-jbacik@fusionio.com> <5213338D.3000205@giantdisaster.de>
In-Reply-To: <5213338D.3000205@giantdisaster.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 8/20/13 4:14 AM, Stefan Behrens wrote:
> On Mon, 19 Aug 2013 16:53:17 -0400, Josef Bacik wrote:
>> There was a problem with send trying to overwrite a file that wasn't actually
>> the same.  This is a test to check this particular case where receive fails when
>> it should succeed properly.  I tested this to verify it fails without my fix and
>> passes with my fix.  Thanks,
> 
> I tested this xfstest but for me it passes with and without the fix
> ("Btrfs: check our parent dir when doing a compare send").

is there any interesting fail-ish output in $seqres.full?

I wonder if it squawked about errors but exited w/ success.

>> $NOT_STDOUT 2>&1 can be dangerous ...

-Eric

