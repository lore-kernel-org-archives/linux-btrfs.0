From: Chris Mason <chris.mason@oracle.com>
Subject: Re: crash when mounting
Date: Mon, 04 Aug 2008 08:47:22 -0400
Message-ID: <1217854042.29139.41.camel@think.oraclecorp.com>
References: <3da3b5b40808021612q1ec112c2jae0769b0abdcceb5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-btrfs@vger.kernel.org
To: Ahmed Kamal <email.ahmedkamal@googlemail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <3da3b5b40808021612q1ec112c2jae0769b0abdcceb5@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2008-08-03 at 02:12 +0300, Ahmed Kamal wrote:
> Hi guys,
> I was playing on vmware with btrfs on complete disks /dev/sd{b,c,d,e}.
> Next I decided to use partitions, so I created /dev/sd{b,c,d,e}1 and
> used those, worked fine! Afterward, I mistakenly re-ran an old command
> on the full disk ( mount -t btrfs -o subvol=. /dev/sdb /mnt/ ) notice
> this is sdb not sdb1, and I got this spectacular kernel freeze. Let me
> know if that's some bug.

It would be nice if we didn't oops, there is clearly some hardening to
do in the failure paths for corrupt filesystems.

-chris


