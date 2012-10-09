Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:45019 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab2JIIl2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 04:41:28 -0400
Date: Tue, 9 Oct 2012 10:39:10 +0200
From: David Sterba <dave@jikos.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>,
        linux-kernel@vger.kernel.org, chris.mason@fusionio.com,
        linux-btrfs@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Richard Purdie <rpurdie@openedhand.com>, David Sterba <dave@jikos.cz>
Subject: Re: ANN: linux-kernel-lzo-2.06.20120123 - update LZO to v2.06
Message-ID: <20121009083910.GI4405@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1326414530-10789-1-git-send-email-andi@firstfloor.org>
 <4F16DFB0.2060404@oberhumer.com>
 <4F1D889C.2050706@oberhumer.com>
 <20120125013618.GA11715@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120125013618.GA11715@one.firstfloor.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 25, 2012 at 02:36:18AM +0100, Andi Kleen wrote:
> I ran benchmarks on the new miniLZO and LZ4 on 64bit. LZ4 is generally slower 
> than snappy/lzo in the micro benchmarks.

And the reason why you measured worse speed for LZ4 although (AFAICT)
everybody else's measurements claim the opposite is quite simple:
likely due to a copy&paste error you did not benchmark LZ4 at all:

https://github.com/andikleen/snappy-c/blob/master/glue.c#L282

274 void test_lz4(char *map, size_t size, char *fn)
275 {
276         int i;
277         int err;
278         size_t outlen = size * 2;
279         char *out = xmalloc(outlen);
280         char *buf2 = xmalloc(size);
281
282         BENCH(fastlz, "lz4", fn, NULL);
                  ^^^^^^

283
284         free(out);
285         free(buf2);
286 }

(LZ4 is on it's track towards kernel)

david
