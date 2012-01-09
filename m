From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: [PATCH 0/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Mon, 9 Jan 2012 08:31:05 -0500
Message-ID: <CALJXSJqgm=1bmrgWVjnbOoWQs3zKu5Wo2quQqM0UwC3ExX9q8g@mail.gmail.com>
References: <cover.1301542804.git.larry@elder-gods.org>
	<20110401133405.GA17956@infradead.org>
	<1301665083-sup-3969@think>
	<201112222324.16871.chris@csamuel.org>
	<4F06E33C.8090104@gmail.com>
	<20120106175713.GS7322@twin.jikos.cz>
	<CAAdM645a0vyaXxoqxTpohNZCJ-=+i380m90wEkcixR62xgiBjQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: dave@jikos.cz, Konstantinos Skarlatos <k.skarlatos@gmail.com>,
	Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>
To: Marios Titas <redneb8888@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAdM645a0vyaXxoqxTpohNZCJ-=+i380m90wEkcixR62xgiBjQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jan 9, 2012 at 1:58 AM, Marios Titas <redneb8888@gmail.com> wrote:
>> The simple case of 'cp --reflink' works fine [...]
>
> It doesn't work here:
>
> cp: failed to clone `/tmp/test': Invalid cross-device link
>
> That's with 3.1 + for-linus.

This is the problem, it doesn't work because you have to apply the
patch at http://permalink.gmane.org/gmane.comp.file-systems.btrfs/9865
which is not mainlined yet. This patch dates back from March 31st, I
have been using it since it was released.
