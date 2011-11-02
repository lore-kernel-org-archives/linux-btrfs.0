From: "Helmut Hullen" <Hullen@t-online.de>
Subject: what does "scrub" mean?
Date: 02 Nov 2011 18:41:00 +0100
Message-ID: <Bx5IeZ5y1uB@helmut.hullen.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo,

I'd like to get some explanations ...


# btrfs filesystem show

Label: 'MMedia'  uuid: 120b036a-883f-46aa-bd9a-cb6a1897c8d2
	Total devices 3 FS bytes used 3.80TB
	devid    1 size 1.82TB used 1.29TB path /dev/sdg1
	devid    3 size 1.81TB used 1.29TB path /dev/sdc1
	devid    2 size 1.81TB used 1.28TB path /dev/sdb1

Btrfs Btrfs v0.19

# btrfs filesystem df /srv/MM

Data, RAID0: total=3.83TB, used=3.80TB
System, RAID1: total=16.00MB, used=248.00KB
System: total=4.00MB, used=0.00
Metadata, RAID1: total=16.25GB, used=4.93GB

# btrfs scrub status /srv/MM

scrub status for 120b036a-883f-46aa-bd9a-cb6a1897c8d2
	scrub resumed at Wed Nov  2 17:02:07 2011 and was aborted after 16519 seconds
	total bytes scrubbed: 1.79TB with 61 errors
	error details: read=4 verify=21 csum=36
	corrected errors: 28, uncorrectable errors: 24, unverified errors: 0

# ------------------------------------------------------------

Why has "scrub" finished its work after less than 1/3 of the bundle?


Viele Gruesse!
Helmut
