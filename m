From: Christoph Hellwig <hch@infradead.org>
Subject: Re: zero-length files in snapshots
Date: Fri, 12 Feb 2010 14:10:46 -0500
Message-ID: <20100212191046.GA3508@infradead.org>
References: <12b5f1ef1002111749u4f33b626jb6a901b29f05337f@mail.gmail.com> <m38wazywow.fsf@pullcord.laptop.org> <93cdabd21002112050x795ab5e2s9bcd426f19032f8c@mail.gmail.com> <20100212151940.GA4191@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mike Fedyk <mfedyk@mikefedyk.com>, Chris Ball <cjb@laptop.org>,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20100212151940.GA4191@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 12, 2010 at 10:19:40AM -0500, Josef Bacik wrote:
> 3) sync - this is not as obvious.  sync doesn't mean anything than "start
> writing back dirty data to the fs", and returns before it's done.  For btrfs
> what that means is we run through _every_ inode that has delalloc pages
> associated with them and start writeback on them.  This will get most of your
> data into the current transaction, which is when the snapshot happens.

sync does return synchronously on Linux, even if that is not guaranted
by Posix.

