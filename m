Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59435 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752004AbdCMRXh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 13 Mar 2017 13:23:37 -0400
Date: Mon, 13 Mar 2017 18:22:58 +0100
From: David Sterba <dsterba@suse.cz>
To: "Lakshmipathi.G" <lakshmipathi.g@giis.co.in>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: misc-tests: Primary Superblock corruption
 and recovery using backup Superblock.
Message-ID: <20170313172258.GP14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170214213125.GA25514@giis.co.in>
 <da0d119a-68eb-a8ed-5cd4-81202da17e8f@cn.fujitsu.com>
 <20170215091405.GA11896@giis.co.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170215091405.GA11896@giis.co.in>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 15, 2017 at 02:44:05PM +0530, Lakshmipathi.G wrote:
> On Wed, Feb 15, 2017 at 09:36:03AM +0800, Qu Wenruo wrote:
> > 
> > 
> > >+	# Corrupt superblock checksum
> > >+        dd if=/dev/zero of=$TEST_DEV seek=$superblock_offset bs=1 \
> > >+        count=4  conv=notrunc &> /dev/null
> > >+	run_check_stdout $SUDO_HELPER mount $TEST_DEV $TEST_MNT | \
> > >+	grep -q 'wrong fs type'
> > 
> > What about using btrfs check instead of trying to mount it?
> > 
> > This could emit the need to use $SUDO_HELPER, and could catch super error
> > more accurate.
> > 
> > >+        if [ $? -ne 0 ]; then
> > >+		_fail "Failed to corrupt superblock."
> > >+        fi
> > >+
> > >+	# Copy backup superblock to primary
> > >+	run_check $TOP/btrfs-select-super -s 1 $TEST_DEV
> > >+	run_check $SUDO_HELPER mount $TEST_DEV $TEST_MNT
> > Same here.
> I started with 'btrfs check' and 'btrfs check --repair' but it seems like
> --repair don't fix the corruption. So just moved away from using it.

Check --repair will not fix the superblock checksum as it's not clear
whether the rest of the superblock is ok or not.
