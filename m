Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40163 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab3BZMnO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 07:43:14 -0500
Date: Tue, 26 Feb 2013 13:43:11 +0100
From: David Sterba <dsterba@suse.cz>
To: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
Cc: chris.mason@fusionio.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        Eric Sandeen <sandeen@redhat.com>, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH, RFC] btrfs-progs: require mkfs -f force option to
 overwrite filesystem or partition table
Message-ID: <20130226124311.GV27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <511D2D2B.8040804@redhat.com>
 <5124EDAB.5020003@giantdisaster.de>
 <512BF648.1090602@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <512BF648.1090602@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 08:39:52AM +0900, Tsutomu Itoh wrote:
> >This means that it is now required to change all occurrences of
> >"mkfs.btrfs" to "mkfs.btrfs -f" everywhere. Can't we first establish a
> 
> I also think so.
> It means -f is not significant to me, I think.
> (Most of my test scripts fails without -f. So I'll always type "mkfs.btrfs -f")
> 
> Therefore I want you to revert commit:2a2d8e1962e8b6cda7b0a7584f6d2fb95d442cb6.
>   btrfs-progs: require mkfs -f force option to overwrite filesystem or partition table

I personally don't want to see it reverted, but also very much understand the
pain to tweak all existing test scripts that rely on direct success of plain
mkfs. To resolve this I'm going to use the attached script, that intsalls
itself in place of mkfs.btrfs and act's as we were used to. This is intended to
help developers and is not for the end user.

david

first use: mkfs.btrfs.wrapper install

---
$ cat mkfs.btrfs.wrapper
#!/bin/sh

if [ $# = 1 -a $1 = 'install' ]; then
	echo "Install mode"
	mkfs=`type -p mkfs.btrfs`
	if [ $? != 0 ]; then
		echo "Cannot find mkfs.btrfs"
		exit 1
	fi
	if file $mkfs | grep -q 'ELF .* executable'; then
		echo "Moving original mkfs to ${mkfs}.real"
		mv $mkfs ${mkfs}.real
		echo "Copying myself to $mkfs"
		cp $0 $mkfs
		chmod 755 $mkfs
		echo "Have a nice day"
		exit 0
	else
		echo "$mkfs is not a binary, will not overwrite"
		exit 1
	fi
fi

mkfs=`type -p mkfs.btrfs.real`
if [ $? != 0 ]; then
	echo "Cannot find mkfs.btrfs.real, install the wrapper properly"
	exit 1
fi
force=

if grep -q 'Use the -f option to force overwrite' $mkfs; then
	force='-f'
fi

$mkfs $force "$@"
---
