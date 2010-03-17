From: jim owens <owens6336@gmail.com>
Subject: extent map merge bad block_len
Date: Wed, 17 Mar 2010 15:27:56 -0400
Message-ID: <4BA12D3C.4000905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Chris,

Something that probably should be fixed is how
merging extent maps with block_len == -1 produces
illegal lengths, as in 8191.

I saw it with holes in directIO and it is not the
cause of my current problems so I'll hope someone
else decides to fix.

jim
