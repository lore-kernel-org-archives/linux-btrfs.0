From: Zach Brown <zab@zabbo.net>
Subject: Re: Fractal Tree Indexing over B-Trees?
Date: Wed, 28 Mar 2012 16:29:44 -0400
Message-ID: <4F7374B8.9050900@zabbo.net>
References: <loom.20120328T160525-464@post.gmane.org> <20120328184204.GB1941@localhost.localdomain> <20120328185720.GC1941@localhost.localdomain> <4F736B6F.2080805@zabbo.net> <20120328201306.GD1941@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Danny Piccirillo <danny.piccirillo@member.fsf.org>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120328201306.GD1941@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>


> I imagine there is, but based on what little information they've shown
> I don't see how it's a hands down win against b-trees.  If anything
> we're talking about having to solve really complex problems in order
> to get any sort of good performance out of this thing.

Oh, absolutely.  Tack on COW and online repair and the complexity goes
through the roof.

- z
