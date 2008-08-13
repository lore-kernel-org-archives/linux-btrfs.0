From: Joe Peterson <lavajoe@gentoo.org>
Subject: Re: New feature Idea
Date: Wed, 13 Aug 2008 13:06:10 -0600
Message-ID: <48A330A2.6020306@gentoo.org>
References: <48A320A0.80609@gmail.com> <48A32DDE.8070203@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Morey Roof <moreyroof@gmail.com>, linux-btrfs@vger.kernel.org
To: jim owens <jowens@hp.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <48A32DDE.8070203@hp.com>
List-ID: <linux-btrfs.vger.kernel.org>

jim owens wrote:
> Don't do it!!!
> 
> OK, I know Chris has described some block sharing.  But I hate it.
> 
> If I copy "resume" to "resume.save", it is because I want 2 copies
> for safety.  I don't want the fs to reduce it to 1 copy.  And
> reducing the duplicates is exactly opposite to Chris's paranoid
> make-multiple-copies-by-default.

Hi Jim,

My thoughts on what you are saying is that it is not generally a good
idea to assume any filesystem will lay things out in any specific way,
including whether it has one-to-one mapping of files to blocks.  In
other words, making a copy of a file on the same filesystem for safety
reasons (unless you are modifying a file and want a backup of its old
state, like emacs' ~ files) is probably not a great habit to get into.

The implementation details of how a filesystem makes things safer should
be behind-the-scenes (like checksums, multiple-copies-by-default,
mirroring, etc.).  That way, you can simply rely on the filesystem to
manage protection of your data rather than going to the effort of
managing multiple copies of files yourself for that reason.

					-Joe
