From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCHv2 02/12]posix_acl: Add the check items
Date: Tue, 22 Dec 2009 14:48:51 +0000
Message-ID: <20091222144851.GS18217@ZenIV.linux.org.uk>
References: <4B2F619A.8000407@gmail.com> <20091222120803.GR18217@ZenIV.linux.org.uk> <b3657a100912220631n4d69ea66x23c1296e1abc468a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chris.mason@oracle.com, joel.becker@oracle.com, cjb@laptop.org,
	jmorris@namei.org, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, onlyflyer@gmail.com,
	strongzgy@gmail.com
To: liu weni <qingshenlwy@gmail.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753426AbZLVOs5@vger.kernel.org>
In-Reply-To: <b3657a100912220631n4d69ea66x23c1296e1abc468a@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 22, 2009 at 10:31:38PM +0800, liu weni wrote:
> Hi All:
> 
>     I'm sorry for my stupid. I am crazy for fixing this bug.
> And make so much mistake.

Welcome to the club.  It's OK, _everyone_ around here had done that.
Many times.

> Maybe I need cool down and think more.
 
Always a good advice, but in this case it's a bit more specific - if you
see that you are modifying behaviour for some arguments, figure out what
would lead to such arguments and see if that behaviour is intentional ;-)
And if after that you are still not sure whether it's a bug or not, ask the
people involved what the hell had they intended to happen in such-and-such
case (often enough that'll bring variants of "nice catch" - bugs *do* happen).
