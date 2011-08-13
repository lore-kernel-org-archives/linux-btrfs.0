From: "krzf83@gmail.com " <krzf83@gmail.com>
Subject: unlink directory with files (rm -d)
Date: Sat, 13 Aug 2011 23:59:34 +0200
Message-ID: <CAJ1PRSnJHJ+fEgYRv3xN+3hzcvtreNZrnqJUszmoK8YjVCn4VA@mail.gmail.com>
References: <CAJ1PRS=9obyg-FRq=V6pZ7J=tccYA_UXWvNzF-6SaywL6rBY9g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAJ1PRS=9obyg-FRq=V6pZ7J=tccYA_UXWvNzF-6SaywL6rBY9g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I wonder if it would be possible to implement instant unlinking
directory with files in it. Since btrfs is based on b trees it could
be possible. Filesystem would have to "loose" all information on
directory and object in it, and allow overwriting this information.
This would be great feature, because everyone knows that recursive
deleting large directories, with milions of files require huge io
traffic.
