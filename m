From: Marios Titas <redneb8888@gmail.com>
Subject: Re: [PATCH 0/2] btrfs: allow cross-subvolume BTRFS_IOC_CLONE
Date: Mon, 9 Jan 2012 01:58:34 -0500
Message-ID: <CAAdM645a0vyaXxoqxTpohNZCJ-=+i380m90wEkcixR62xgiBjQ@mail.gmail.com>
References: <cover.1301542804.git.larry@elder-gods.org>
	<20110401133405.GA17956@infradead.org>
	<1301665083-sup-3969@think>
	<201112222324.16871.chris@csamuel.org>
	<4F06E33C.8090104@gmail.com>
	<20120106175713.GS7322@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, Konstantinos Skarlatos <k.skarlatos@gmail.com>,
	Chris Samuel <chris@csamuel.org>, linux-btrfs@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120106175713.GS7322@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 6, 2012 at 12:57, David Sterba <dave@jikos.cz> wrote:
> On Fri, Jan 06, 2012 at 02:04:12PM +0200, Konstantinos Skarlatos wrote:
>> Me too wants cp --reflink across subvolumes. Please make this feature
>> available to us, as its a "poor man's dedupe" and would give big space
>> savings for many use cases.
>
> The simple case of 'cp --reflink' works fine [...]

It doesn't work here:

cp: failed to clone `/tmp/test': Invalid cross-device link

That's with 3.1 + for-linus.
