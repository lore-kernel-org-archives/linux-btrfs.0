From: "Miguel Sousa Filipe" <miguel.filipe@gmail.com>
Subject: [PATCH] initial version of reference cache
Date: Mon, 28 Jul 2008 17:53:50 +0100
Message-ID: <f058a9c30807280953k6cac85a1i9bc10bf41cdb23d7@mail.gmail.com>
References: <21782573.1217014155193.JavaMail.oracle@acsmt304.oracle.com>
	 <1217257799.7572.103.camel@think.oraclecorp.com>
	 <f058a9c30807280952m2386aad4pa8a08ffaf930c370@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <f058a9c30807280952m2386aad4pa8a08ffaf930c370@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

On Mon, Jul 28, 2008 at 4:09 PM, Chris Mason <chris.mason@oracle.com> wrote:
> Yan and I are hammering this out a little, I've attached my current
> patches.
>
> I was seeing cache misses after long stress runs, which I think is
> coming from references on the higher levels of the tree making us skip
> some leaves while dropping the transaction that added them.
>
> My new version using a single cache per root, and should avoid these
> misses.

Just curious, what is the cache size and or eviction policy?
Is it LFU or LRU, fifo, something custom? Would ARC be a good policy
for this purpose?

Sorry if this is totally off-topic or clueless, just curious.. hell,
I'm not even shure what data/info/object is the cache for...

Kind regards,


--
Miguel Sousa Filipe
