From: Zach Brown <zab@zabbo.net>
Subject: Re: hard links
Date: Wed, 04 Apr 2012 16:57:11 -0400
Message-ID: <4F7CB5A7.4000907@zabbo.net>
References: <4F7C78FE.2020508@arndnet.de> <4F7CA218.5070902@gmail.com> <4F7CA37B.50006@arndnet.de> <20120404195339.GE32070@carfax.org.uk> <4F7CAB3E.1050800@arndnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Cc: Hugo Mills <hugo@carfax.org.uk>, nspmangalore@gmail.com,
	linux-btrfs@vger.kernel.org
To: Arnd Hannemann <arnd@arndnet.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F7CAB3E.1050800@arndnet.de>
List-ID: <linux-btrfs.vger.kernel.org>


> My understanding is that the limit on the number of hardlinks to the same
> file stored in the same directory, is, because the names of the
> hardlinks are stored within the same inode. As such the number of hardlinks is
> naturally limited by the size of the inode (and dependent on the length
> of the filenames). Correct?

Correct enough :).  Yes, there is a limited amount of space associated
with an inode that tracks hard links and the name of the link consumes
that space.

The details are a little different.  The backrefs to a given inode are
stored in one item in the tree whose size is limited by the block size
of the leaves in the tree.

> It's not a big deal, but with my original posting I just tried to
> point out that btrfs fails an operation while the above constraint is
> not violated.  The size needed to store the filename "a" is exactly
> the same as the size needed to store the filename "b".  Therefore, I
> would assume the operation mv "a" "b" to just work.

Huh, indeed.

I'd hope that the current behaviour could be fixed.  In flipping through
the code it certainly looks like it adds the new backref for the new
name before it unlinks the old name and removes the old backref.

- z
