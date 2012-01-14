From: Sander <sander@humilis.net>
Subject: Re: Can't resize second device in RAID1
Date: Sat, 14 Jan 2012 15:42:36 +0100
Message-ID: <20120114144236.GA22603@attic.humilis.net>
References: <CADy=jfVZjRAE049OiD6VkoKkpzZh9e_=V62AvuVwxyHZyfuU1w@mail.gmail.com>
 <CADy=jfWbzq81CrhCFy+RVd8e7265XZgkqomwOOxYaKehSpzasQ@mail.gmail.com>
 <20120113231717.GB21769@carfax.org.uk>
 <CADy=jfU88LRMw4Jmk4O_n+URRQxN2EUpiZCZe7GVK_LHPShmZA@mail.gmail.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
To: "Marco L. Crociani" <marco.crociani@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CADy=jfU88LRMw4Jmk4O_n+URRQxN2EUpiZCZe7GVK_LHPShmZA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Marco L. Crociani wrote (ao):
> On Sat, Jan 14, 2012 at 12:17 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> > On Sat, Jan 14, 2012 at 12:12:06AM +0100, Marco L. Crociani wrote:
> >> # ./btrfs fi sh
> >> Label: 'RootFS'?? uuid: c87975a0-a575-405e-9890-d3f7f25bbd96
> >> ?????? Total devices 2 FS bytes used 284.98GB
> >> ?????? devid?????? 2 size 311.82GB used 286.51GB path /dev/sdb3
> >> ?????? devid?????? 1 size 897.76GB used 286.51GB path /dev/sda3
> >>
> >> /dev/sdb3 is the same.
> >>
> >> How can I resize /dev/sdb3?
> >
> > ?? I think the syntax you need is btrfs fi resize max /mnt/RootFS:2

> ./btrfs fi resize max /mnt/RootFS:2
> ERROR: can't access to '/mnt/RootFS:2'

btrfs filesystem resize 2:max /mnt/RootFS

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
