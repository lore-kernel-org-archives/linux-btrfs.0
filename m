From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: Compession, on filesystem or volume?
Date: Thu, 29 Dec 2011 18:11:16 +0700
Message-ID: <CAG1y0sf2QFbD5_6xK1iHtdaBLBtZsNFgk1KrTpavNfZQX-CH1w@mail.gmail.com>
References: <4EFC4617.5070109@hosman.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Remco Hosman <remco@hosman.xs4all.nl>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EFC4617.5070109@hosman.xs4all.nl>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 29, 2011 at 5:51 PM, Remco Hosman <remco@hosman.xs4all.nl> wrote:
> Hi,
>
> Something i could not find in the documentation i managed to find:
> if you mount with compress=lzo and rebalance, is compression on for that
> filesystem or only a single volume?
>
> eg, can i have a @boot volume uncompressed and @ and @home compressed.

Last time I asked a similar question, the answer was no. It's per filesystem.

however you can change compression of individual files between
zlib/lzo using "btrfs fi defragment -c", regardless of what the
filesystem is currently mounted with.

-- 
Fajar
