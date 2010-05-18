From: Josef Bacik <josef@redhat.com>
Subject: Re: Encryption in btrfs
Date: Tue, 18 May 2010 15:03:59 -0400
Message-ID: <20100518190358.GA3108@localhost.localdomain>
References: <AANLkTilBRFysT-FvWjYqGUQIzWZf8HEmBQz9P0Ck9kNm@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Jay Sullivan <notfed@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTilBRFysT-FvWjYqGUQIzWZf8HEmBQz9P0Ck9kNm@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 18, 2010 at 02:54:35PM -0400, Jay Sullivan wrote:
> Hi,
>=20
>     In the past, I've heard rumors that there are plans to support
> [transparent] encryption in btrfs. =A0If you guys were able to get
> compression to work already, I don't see what's stopping you from
> implementing encryption. =A0I'd like to strongly recommend that you l=
ook
> into using=A0the "NaCl: Networking and Cryptography library" (see
> http://nacl.cace-project.eu/ =A0) by Daniel J. Bernstein.  It is
> extremely lightweight, fast, secure, and has an extremely simple API.
>  I'd really like to see btrfs take advantage of such a great
> cryptographic library.  I'm interested in hearing all of your thought=
s
> on this, as I think it could work out quite nicely.
>=20

Whenever somebody manages to get around to encryption it will likely us=
e the
built in crypto library already in the kernel so we don't go around dup=
licating
code.  Thanks,

Josef
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
