From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: strange btrfs sub list output
Date: Fri, 27 May 2011 10:01:26 +0100
Message-ID: <chaz20110527090126.GD27537@seebyte.com>
References: <20110526212203.GA4611@yahoo.fr> <chaz20110527080157.GA27537@seebyte.com> <4DDF5EEF.6060706@gmail.com> <chaz20110527084733.GC27537@seebyte.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Andreas Philipp <philipp.andreas@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <chaz20110527084733.GC27537@seebyte.com>
List-ID: <linux-btrfs.vger.kernel.org>

Is there a way to derive the subvolume ID from the stat(2)
st_dev, by the way.

# btrfs sub list .
ID 256 top level 5 path a
ID 257 top level 5 path b
# zstat +dev . a b
. 27
a 28
b 29

Are the dev numbers allocated in the same order as the
subvolids? Would there be any /sys, /proc, ioctl interface to
get this kind of information?

-- 
Stephane
