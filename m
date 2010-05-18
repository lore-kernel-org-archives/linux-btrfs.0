From: Jay Sullivan <notfed@gmail.com>
Subject: Encryption in btrfs
Date: Tue, 18 May 2010 14:54:35 -0400
Message-ID: <AANLkTilBRFysT-FvWjYqGUQIzWZf8HEmBQz9P0Ck9kNm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

    In the past, I've heard rumors that there are plans to support
[transparent] encryption in btrfs. =C2=A0If you guys were able to get
compression to work already, I don't see what's stopping you from
implementing encryption. =C2=A0I'd like to strongly recommend that you =
look
into using=C2=A0the "NaCl: Networking and Cryptography library" (see
http://nacl.cace-project.eu/ =C2=A0) by Daniel J. Bernstein.  It is
extremely lightweight, fast, secure, and has an extremely simple API.
 I'd really like to see btrfs take advantage of such a great
cryptographic library.  I'm interested in hearing all of your thoughts
on this, as I think it could work out quite nicely.

Thanks!

--
Jay Sullivan
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
