From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: Btrfs trees for linux-next
Date: Mon, 15 Dec 2008 23:55:20 +0100
Message-ID: <ac3eb2510812151455h27b790av9579b670edbca7ab@mail.gmail.com>
References: <1227183484.6161.17.camel@think.oraclecorp.com>
	 <1228962896.21376.11.camel@think.oraclecorp.com>
	 <20081211141436.030c2d65.sfr@canb.auug.org.au>
	 <20081210200604.8e190b0d.akpm@linux-foundation.org>
	 <1229006596.22236.46.camel@think.oraclecorp.com>
	 <20081215210323.GB5000@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Chris Mason" <chris.mason@oracle.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Stephen Rothwell" <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
To: "Andreas Dilger" <adilger@sun.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081215210323.GB5000@webber.adilger.int>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 15, 2008 at 22:03, Andreas Dilger <adilger@sun.com> wrote:
> On Dec 11, 2008  09:43 -0500, Chris Mason wrote:
>> The multi-device code uses a very simple brute force scan from userland
>> to populate the list of devices that belong to a given FS.  Kay Sievers
>> has some ideas on hotplug magic to make this less dumb.  (The scan isn't
>> required for single device filesystems).
>
> This should use libblkid to do the scanning of the devices, and it can
> cache the results for efficiency.  Best would be to have the same LABEL+UUID
> for all devices in the same filesystem, and then once any of these devices
> are found the mount.btrfs code can query the rest of the devices to find
> the remaining parts of the filesystem.

Which is another way to do something you should not do that way in the
first place, just with a library instead of your own code.

Brute-force scanning /dev with a single thread will not work reliably
in many setups we need to support. Sure, it's good to have it for a
rescue system, it will work fine or your workstation, but definitely
not for boxes with many devices where you don't know how they behave.

Just do:
  $ modprobe scsi_debug max_luns=8 num_parts=2
  $ echo 1 > /sys/module/scsi_debug/parameters/every_nth
  $ echo 4 > /sys/module/scsi_debug/parameters/opts

  $ ls -l /sys/class/block/ | wc -l
  45
and then call any binary doing /dev scanning, and wait (in this case)
for ~2 hours to return.

Also, the blkid cache file uses major/minor numbers or kernel device
names, which will also not help in many setups we have to support
today.

The original btrfs topic, leading to this, is here:
  http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg01048.html

Thanks,
Kay
