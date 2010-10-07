From: Roman Kapusta <roman.kapusta@gmail.com>
Subject: performance of cp and mv between subvolumes
Date: Thu, 7 Oct 2010 11:57:02 +0200
Message-ID: <AANLkTi=yk9zZuF-tTOgGj1Vt2=WHOOH5BYyzX+3sBdTZ@mail.gmail.com>
References: <AANLkTikwYXktHD7-H7LF+cn7zBpY8ZdDw+z=Zze1-C+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTikwYXktHD7-H7LF+cn7zBpY8ZdDw+z=Zze1-C+w@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Shouldn't be possible to move or copy (COW) big files between two
subvolumes of one btrfs filesystem instantly - without real data
movement?

cp --reflink between subvolumes is returning error: cp: failed to
clone `...': Invalid cross-device link
mv between subvolumes is really slow - looks like it is moving all data

To circumvent this I can create new snapshot and then remove
everything except files I want to copy/move to this new subvolume and
I gained the same effect quite fast, but indirectly, is there some way
how to do it directly when subvolume already exists?

Roman Kapusta
