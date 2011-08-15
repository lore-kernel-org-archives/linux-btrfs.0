From: Chris Mason <chris.mason@oracle.com>
Subject: Re: unlink directory with files (rm -d)
Date: Mon, 15 Aug 2011 11:58:50 -0400
Message-ID: <1313423885-sup-4133@shiny>
References: <CAJ1PRS=9obyg-FRq=V6pZ7J=tccYA_UXWvNzF-6SaywL6rBY9g@mail.gmail.com> <CAJ1PRSnJHJ+fEgYRv3xN+3hzcvtreNZrnqJUszmoK8YjVCn4VA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "krzf83@gmail.com" <krzf83@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <CAJ1PRSnJHJ+fEgYRv3xN+3hzcvtreNZrnqJUszmoK8YjVCn4VA@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from krzf83@gmail.com's message of 2011-08-13 17:59:34 -0400:
> I wonder if it would be possible to implement instant unlinking
> directory with files in it. Since btrfs is based on b trees it could
> be possible. Filesystem would have to "loose" all information on
> directory and object in it, and allow overwriting this information.
> This would be great feature, because everyone knows that recursive
> deleting large directories, with milions of files require huge io
> traffic.

I'm afraid the huge IO traffic is required in order to find the files in
the directory and free all the blocks reference by those files.

-chris
