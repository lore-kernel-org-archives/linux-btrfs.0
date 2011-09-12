From: Grazvydas Ignotas <notasas@gmail.com>
Subject: Re: [PATCH] btrfs: fix directory offsets for '.' and '..' entries
Date: Mon, 12 Sep 2011 03:21:11 +0300
Message-ID: <CANOLnON5akaYFTuZu4bqJ9BSA4Dt5Ut9tXZGPyQMNDeHt_6vvA@mail.gmail.com>
References: <1315773216-8490-1-git-send-email-notasas@gmail.com>
	<20110911210624.GA17583@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110911210624.GA17583@infradead.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 12, 2011 at 12:06 AM, Christoph Hellwig <hch@infradead.org>=
 wrote:
> On Sun, Sep 11, 2011 at 11:33:36PM +0300, Grazvydas Ignotas wrote:
>> Currently getdents syscall returns wrong offset for '.' directory en=
try,
>> which confuses some programs like wine. This can be observed with an
>> example program getdents(2) manpage:
>
> Can you submit a patch to add your testcase to xfstests?

Sent, hopefully did it right.


--=20
Gra=C5=BEvydas
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
