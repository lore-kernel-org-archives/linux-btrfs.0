From: Stephane CHAZELAS <stephane_chazelas@yahoo.fr>
Subject: Re: status of raid10 reliability
Date: Thu, 17 Nov 2011 22:36:16 +0000
Message-ID: <chaz20111117223616.GA5544@seebyte.com>
References: <slrnjcafu5.fao.stephane.chazelas@spam.is.invalid>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <slrnjcafu5.fao.stephane.chazelas@spam.is.invalid>
List-ID: <linux-btrfs.vger.kernel.org>

2011-11-17 17:09:25 +0000, Stephane CHAZELAS:
[...]
> Before setting up a new RAID10 btrfs array with 6 drives, I
> wanted to check how good it behaved in case of disk failure.
> I've not been too impressed. Is RAID10 btrfs support only
> meant for reading performance improvement?
> 
> My test method was:
> 
> Use the device-mapper to have devices mapped (linear) to loop
> devices
[...]
> Then write some data, and then use DM's error target to simulate
> a failing drive (all I/O ends up in error):
> 
> # dmsetup suspend hd3; echo 0 $s error | dmsetup reload hd3; dmsetup resume hd3
[...]

Note that I did the same test with both md (raid10) and
zfsonlinux (raidz) and it worked as expected.

-- 
Stephane
