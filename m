Return-Path: <SRS0=q+/I=5R=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C4AC43331
	for <linux-btrfs@archiver.kernel.org>; Wed,  1 Apr 2020 18:36:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6393A20784
	for <linux-btrfs@archiver.kernel.org>; Wed,  1 Apr 2020 18:36:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732355AbgDASgN (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 1 Apr 2020 14:36:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:42804 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732308AbgDASgN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 1 Apr 2020 14:36:13 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 84546ABE9;
        Wed,  1 Apr 2020 18:36:11 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 82689DA727; Wed,  1 Apr 2020 20:35:37 +0200 (CEST)
Date:   Wed, 1 Apr 2020 20:35:37 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2] btrfs-progs: fix misc-test/029 provide device for
 mount
Message-ID: <20200401183537.GA5920@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org
References: <1585125129-11224-1-git-send-email-anand.jain@oracle.com>
 <1585125129-11224-2-git-send-email-anand.jain@oracle.com>
 <20200326154609.GH5920@twin.jikos.cz>
 <a6267fcd-28e1-6763-8c91-1a50758f9324@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6267fcd-28e1-6763-8c91-1a50758f9324@oracle.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 27, 2020 at 12:15:45PM +0800, Anand Jain wrote:
> 
> 
> On 3/26/20 11:46 PM, David Sterba wrote:
> > On Wed, Mar 25, 2020 at 04:32:09PM +0800, Anand Jain wrote:
> >> The mount fails with 'file exists' error. Fix it by providing the device
> >> name.
> > 
> > Can you be more specific about the environment where it fails? The test
> > passes for me.
> > 
> 
> I am running it as
> 
> /btrfs-progs$ make TEST=029\* test-misc
>      [TEST]   misc-tests.sh
>      [TEST/misc]   029-send-p-different-mountpoints
> failed: mount -t btrfs -o subvol=subv1 /btrfs-progs/tests//test.img 
> /btrfs-progs/tests/misc-tests/029-send-p-different-mountpoints/subvol_mnt
> test failed for case 029-send-p-different-mountpoints
> make: *** [test-misc] Error 1

That command works fine and the path of image has double slashes too:

$ make TEST=029\* test-misc
    [TEST]   misc-tests.sh
    [TEST/misc]   029-send-p-different-mountpoints

From the log, the first run of mount:

RUN CHECK root_helper mount -t btrfs -o loop /btrfs-progs/tests//test.img /btrfs-progs/tests//mnt

> >> --- a/tests/misc-tests/029-send-p-different-mountpoints/test.sh
> >> +++ b/tests/misc-tests/029-send-p-different-mountpoints/test.sh
> >> @@ -19,8 +19,10 @@ run_mayfail $SUDO_HELPER mkdir -p "$SUBVOL_MNT" ||
> >>   run_check_mkfs_test_dev
> >>   run_check_mount_test_dev
> >>   
> >> +# The sed part is to replace double forward-slash with single forward-slash
> >> +lodev=$(losetup  | grep $(echo $TEST_DEV | sed 's/\/\//\//') | awk '{print $1}')
> > 
> > There's a simpler way to canonicalize a path, eg using readlink or
> > realpath.
> 
>   Err. yep. I will fix.
> 
> > And I don't see why would two slashes appear in a path. IIRC a path
> > starting with two slashes is standardized as a network path and
> > recognized by VFS but why this is a concern for the testsuite?
> 
> The mount finds the path given is an image file and tries to add another
> loop device to it (as I understand the above error), now I wonder
> it should fail in your environment as well. If my understand is only
> true.

Instead of patching the tests, the path to TEST_DEV should be
canonicalized in prepare_test_dev or initialization of TEST_DEV should
not put the slash at the end in the test driver scripts.

tests/misc-tests.sh:
...
TEST_TOP="$TOP/tests/"
