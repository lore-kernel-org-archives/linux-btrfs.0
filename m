From: Calvin Walton <calvin.walton@kepstin.ca>
Subject: Re: Test Trim
Date: Wed, 12 Oct 2011 20:47:10 -0400
Message-ID: <1318466830.2208.4.camel@nayuki.kepstin.ca>
References: <CAAeznTpywAkHPc5kqnS7nqxf24Bg1OXohsDfVoWo=aBDvOcK6A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-btrfs@vger.kernel.org
To: Leonidas Spyropoulos <artafinde@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAeznTpywAkHPc5kqnS7nqxf24Bg1OXohsDfVoWo=aBDvOcK6A@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 2011-10-11 at 08:35 +0100, Leonidas Spyropoulos wrote:
> Hello list,
> 
> Is there a small script to test if TRIM is working on my system?
> 
> Also what about defrag? Is it recommended and how importatnt? Can I
> check if I need it?

If you're asking about TRIM, then you're probably using btrfs on an SSD.
On an SSD, the defrag may help somewhat - due to reducing the number of
extents that a file is stored in, causing fewer, larger reads. But the
random read speed of a good SSD is high enough that unless a file is
really, severely fragmented, you probably won't notice.

On the other hand, enabling defrag will cause files to be rewritten
occasionally, which will use additional write cycles on your flash
memory cells.

Unless you're experiencing performance problems, I would recommend you
leave the autodefrag option disabled on an SSD.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

