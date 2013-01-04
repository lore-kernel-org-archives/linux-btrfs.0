Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754631Ab3ADNpt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 4 Jan 2013 08:45:49 -0500
Date: Fri, 4 Jan 2013 14:45:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <chris.mason@fusionio.com>, David Sterba <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: [bug] csum mismatches and failed xfstests with 3.8-rc1
Message-ID: <20130104134547.GG20089@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130104125059.GE20089@twin.jikos.cz>
 <20130104130144.GF14537@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130104130144.GF14537@shiny>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 04, 2013 at 08:01:44AM -0500, Chris Mason wrote:
> > I'm not quite sure if the messages match the test (best guess, neighbouring
> > tests were fine):
> > 
> > [102885.667444] btrfs csum failed ino 638 off 425984 csum 1842675109 private 2279232751
> > [102885.676804] btrfs csum failed ino 638 off 430080 csum 1842675109 private 1192041375
> > [102885.686094] btrfs csum failed ino 638 off 434176 csum 2297282744 private 1619428542
> > [102885.686103] btrfs csum failed ino 638 off 438272 csum 3709984297 private 2868627320
> > [102885.686112] btrfs csum failed ino 638 off 442368 csum 1504116677 private 1239355148
> > [102885.686121] btrfs csum failed ino 638 off 446464 csum 1957839041 private 3848200057
> > [102885.686129] btrfs csum failed ino 638 off 450560 csum 3836729483 private 2867416946
> 
> I think fsx leaves the bad file, you can test the inode number?

# btrfs inspect ino 638 /mnt/a1
/mnt/a1/junk

# md5sum /mnt/a1/junk
md5sum: /mnt/a1/junk: Input/output error

dmesg says:
[165711.839959] btrfs csum failed ino 638 off 262144 csum 3105135418 private 2393479556
[165711.899328] btrfs csum failed ino 638 off 262144 csum 2566472073 private 2393479556
