From: wks1986 <wks1986@gmail.com>
Subject: A device dedicated for metadata?
Date: Wed, 28 Jul 2010 17:32:01 +0800
Message-ID: <AANLkTik3Mrf+vY6qW6TTtGEghm48ma8tjiWYGfcLhhMq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello

Recently I am learning about the Btrfs.

My requirement is to construct a cross-device btrfs volume consisting
of a single SSD and many (much larger) HDDs.  The tricky part is that
I want the SSD to be dedicated to metadata since SSDs are much faster
(and more expensive) than HDDs and metadata are much more frequently
queried than data.  And I do not want ordinary data to use up the
precious space on the SSD in case there would be no room for metadata.

I have figured out that I can keep the metadata stored inside the
first device by applying the "-m single" option to mkfs.btrfs.
However, I do not know how to require that data should NOT be
allocated on the SSD.  I read the mkfs code.  It appears to me that it
can be worked around by excluding the SSD from the "raid group" for
ordinary data.

A recent patch have been proposed to move "hot" (according to
statistics) data to SSDs in order to improve performance.  My case is
similar, but I know in advance that metadata are hotter.

I am not very confident about what I have found, so I need some
comment.  Is it necessary to modify the Btrfs code?  On the other
hand, I have not figured out exactly how much metadata there would be
with a given amount of data.  How significant will it be to exclude
ordinary data from the SSD?

Kunshan Wang
