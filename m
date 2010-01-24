From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: mount after reboot of btrfs RAID-10 fails with "btrfs: failed to read the system array on sda"
Date: Sun, 24 Jan 2010 09:02:38 +0100
Message-ID: <201001240902.38535.kreijack@libero.it>
References: <c67eed301001232153j5cb755f6ge2924df740d750d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: 0bo0 <0.bugs.only.0@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <c67eed301001232153j5cb755f6ge2924df740d750d8@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sunday 24 January 2010, 0bo0 wrote:
> after a simple reboot,
                 ^^^^^^
Have you do

  # btrfsctl -a

before mounting the filesystem ? This command scans all the block devices 
searching the btrfs volume. So when you mount a device of an array the system 
is able to retrieves the others.

[..]

-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
