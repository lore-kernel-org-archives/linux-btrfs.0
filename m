From: =?UTF-8?Q?Pawe=C5=82_Brodacki?= <pawel.brodacki@googlemail.com>
Subject: btrfs vs data deduplication
Date: Sat, 9 Jul 2011 08:19:30 +0200
Message-ID: <CACVpCE7ZSjgT9+h2DfHAR_n=4LqHguOSVaNzE3YcnZ5Bb00_Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I've stumbled upon this article:
http://storagemojo.com/2011/06/27/de-dup-too-much-of-good-thing/

Reportedly Sandforce SF1200 SSD controller does internally block-level
data de-duplication. This effectively removes the additional
protection given by writing multiple metadata copies. This technique
may be used, or can be used in the future by manufactureres of other
drives too.

I would like to ask, if the metadata copies written to a btrfs system
with enabled metadata mirroring are identical, or is there something
that makes them unique on-disk, therefore preventing their
de-duplication. I tried googling for the answer, but didn't net
anything that would answer my question.

If the metadata copies are identical, I'd like to ask if it would be
possible to change this without major disruption? I know that changes
to on-disk format aren't a thing made lightly, but I'd be grateful for
any comments.

The increase of the risk of file system corruption introduced by data
de-duplication on Sandforce controllers was down-played in the
vendor's reply included in the article, but still, what's the point of
duplicating metadata on file system level, if storage below can remove
that redundancy?

Regards,
Pawe=C5=82
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
