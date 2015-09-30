Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39780 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932766AbbI3WOS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Sep 2015 18:14:18 -0400
Subject: Re: [RFC PATCH] fstests: generic: Test that fsync works on file in
 overlayfs merged directory
To: Dave Chinner <david@fromorbit.com>, Roman Lebedev <lebedev.ri@gmail.com>
References: <1443643065-16460-1-git-send-email-lebedev.ri@gmail.com>
 <1443643065-16460-2-git-send-email-lebedev.ri@gmail.com>
 <20150930215640.GH27164@dastard>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <560C5D3A.8010800@sandeen.net>
Date: Wed, 30 Sep 2015 17:07:54 -0500
MIME-Version: 1.0
In-Reply-To: <20150930215640.GH27164@dastard>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 9/30/15 4:56 PM, Dave Chinner wrote:
> On Wed, Sep 30, 2015 at 10:57:45PM +0300, Roman Lebedev wrote:
>> As per overlayfs documentation, any activity on a merged directory
>> for a application that is doing such activity should work exactly
>> as if that would be a normal, non overlayfs-merged directory.
>>
>> That is, e.g. simple fopen-fwrite-fsync-fclose sequence should
>> work just fine.
> 
> We have plenty of tests that do things like that.
> 
>> But apparently it does not. Add a simple generic test to check that.
>> As of right now (linux-4.2.1) this test fails at least on btrfs.
>>
>> PS: An alternative (and probably better approach) would be to run
>> fstests test suite with TEST_DIR set to overlayfs work directory.
> 
> Much better is to run xfstests directly on overlayfs. THere have
> been some patches to do that posted in the past, but those patches
> and discussions kinda ended up going nowhere:
> 
> http://www.mail-archive.com/fstests@vger.kernel.org/msg00474.html
> 
> Perhaps you'd like to pick this up, and then overlay will by much
> easier to test and hence likely not to have bugs like this...

Yeah, that could still be used for fun, but Zach's POV was that
we should just have a specific overlayfs config (dictating paths
to over/under/merge/around/through/whatever directories), a special
mount_overlayfs helper, etc, ala NFS & CIFS.  It may actually be
easier than what I proposed.

If you want to take a stab at it I'm happy to help, answer questions,
etc - I'm not sure when I'll get back to it...

-Eric
