Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45030 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752763AbdCHMOC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 8 Mar 2017 07:14:02 -0500
Date: Wed, 8 Mar 2017 12:59:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Btrfs progs pre-release 4.10-rc1
Message-ID: <20170308115939.GZ4662@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170302145947.14775-1-dsterba@suse.com>
 <35e4a389-f8aa-6da7-b971-607744ed8c44@jp.fujitsu.com>
 <20170307115446.GR4662@suse.cz>
 <0c346a54-9ed3-826a-8a98-adcc33df0527@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0c346a54-9ed3-826a-8a98-adcc33df0527@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 08, 2017 at 09:11:37AM +0900, Tsutomu Itoh wrote:
> >>>
> >>> Benedikt Morbach (1):
> >>>       btrfs-progs: send-dump: add missing newlines
> >>>
> >>> David Sterba (102):
> >>
> >>>       btrfs-progs: rework option parser to use getopt for global options
> >>
> >> I think that btrfs/{008,016,019,...} of xfstests has failed due to the
> >> above patch.
> >>
> >> btrfs/008 1s ... [failed, exit status 1] - output mismatch (see /xfstests/results//btrfs/008.out.bad)
> >>     --- tests/btrfs/008.out     2015-08-04 16:09:38.000000000 +0900
> >>     +++ /xfstests/results//btrfs/008.out.bad    2017-03-07 09:00:50.581906234 +0900
> >>     @@ -1,2 +1,3 @@
> >>      QA output created by 008
> >>     -Silence is golden
> >>     +send failed
> >>     +(see /xfstests/results//btrfs/008.full for details)
> > 
> > What's in the .full report?
> 
> $ cat 008.full
> Create subvolume '/test5/send_temp_008/send'
> Create a readonly snapshot of '/test5/send_temp_008/send' in '/test5/send_temp_008/send/snapshots/backup2'
> Create a readonly snapshot of '/test5/send_temp_008/send' in '/test5/send_temp_008/send/snapshots/backup3'
> ERROR: unable to resolve -f
> send failed

So it's because the newly added global options make option parsing more
strict and the fstests do not follow the order where options come first:

eg. from 008:

 80 $BTRFS_UTIL_PROG send $work_dir/snapshots/backup3/ -f $TEST_DIR/$tmp_dir/blah \
 81         >> $seqres.full 2>&1 || _fail "send failed"

ie "$work_dir/snapshots/backup3/" is non-option argument but "-f" is an
option. This is normally accepted by getopt as it reorders the arguments
so that options are always first.

I will delay the patch so that the fstests won't fail but this needs to
be fixed soon as the newly added global options are building block for
other enhancements.
