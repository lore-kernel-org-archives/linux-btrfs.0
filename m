From: Skylar Burtenshaw <daninfuchs@gmail.com>
Subject: Re: Can't mount, power failure - recoverable?
Date: Sat, 17 Mar 2012 19:06:33 +0000 (UTC)
Message-ID: <loom.20120317T193612-305@post.gmane.org>
References: <loom.20120317T051243-551@post.gmane.org> <20120317103140.GA3172@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

>    Can you give us the last, say, 200 lines of find-root's output?
First line:
Super think's the tree root is at 12653942837248, chunk root 20975616

Last bunch of lines:
Well block 12154942255104 seems great, but generation doesn't match,
have=267067, want=267118
Well block 12154943320064 seems great, but generation doesn't match,
have=267070, want=267118
Well block 12154952667136 seems great, but generation doesn't match,
have=267082, want=267118
Well block 12154988584960 seems great, but generation doesn't match,
have=267090, want=267118
Well block 12377338957824 seems great, but generation doesn't match,
have=267074, want=267118
Well block 12377342033920 seems great, but generation doesn't match,
have=267098, want=267118
Well block 12377342611456 seems great, but generation doesn't match,
have=267077, want=267118
Well block 12377458331648 seems great, but generation doesn't match,
have=267080, want=267118
Well block 12377624317952 seems great, but generation doesn't match,
have=267095, want=267118
Well block 12514222108672 seems great, but generation doesn't match,
have=267100, want=267118
Well block 12514227576832 seems great, but generation doesn't match,
have=267101, want=267118
Well block 12514233110528 seems great, but generation doesn't match,
have=267106, want=267118
Well block 12514240315392 seems great, but generation doesn't match,
have=267114, want=267118
Well block 12514243575808 seems great, but generation doesn't match,
have=267112, want=267118
Well block 12514243645440 seems great, but generation doesn't match,
have=267113, want=267118
Well block 12514243678208 seems great, but generation doesn't match,
have=267116, want=267118
Well block 12514252976128 seems great, but generation doesn't match,
have=267117, want=267118
Found tree root at 12653942837248

There are roughly 2000 lines of:
"Well block X seems great, but generation doesn't match, have=X want=267118"

They ALL want 267118, and only the first line and the last line (both shown) are
different.

