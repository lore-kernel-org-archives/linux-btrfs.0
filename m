From: "Roland" <devzero@web.de>
Subject: weird bash autocomplete issue
Date: Tue, 16 Dec 2008 20:37:30 +0100
Message-ID: <098b01c95fb5$bc2d1440$0301a8c0@bui.materna.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
To: <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

hi,

i have come across a weird autocomplete issue i assume it is related to 
btrfs.

let`s have some dirs:

/non-btrfs-mount
    ./linux
    ./testdir

/brtfs-mount
    ./linux
    ./testdir

now, if i do "cd t<tab>" in /non-btrfs-mount, "t" autocompletes to "testdir"
same for l<tab>inux - bash autocompletes as expected.

now, the weird thing is, that on /btrfs-mount this behaves different.

autocompletion for testdir works, but not for linux dir. weird.

can someone reproduce this ?

i`m on opensuse 11.1 with 2.6.27.8-1-default and latest btrfs-unstable from 
git.

regards
roland 

