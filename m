From: Jeff Mahoney <jeffm@suse.com>
Subject: Re: [patch 01/99] btrfs: Add btrfs_panic()
Date: Wed, 23 Nov 2011 21:22:06 -0500
Message-ID: <4ECDAA4E.9000201@suse.com>
References: <20111124003533.395674389@suse.com> <20111124004219.933819241@suse.com> <20111124020533.GA14982@davidb.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Btrfs List <linux-btrfs@vger.kernel.org>
To: David Brown <davidb@davidb.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111124020533.GA14982@davidb.org>
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/23/2011 09:05 PM, David Brown wrote:
> On Wed, Nov 23, 2011 at 07:35:34PM -0500, Jeff Mahoney wrote:
>> As part of the effort to eliminate BUG_ON as an error handling 
>> technique, we need to determine which errors are actual logic
>> errors, which are on-disk corruption, and which are normal
>> runtime errors e.g. -ENOMEM.
>> 
>> Annotating these error cases is helpful to understand and report
>> them.
>> 
>> This patch adds a btrfs_panic() routine that will either panic or
>> BUG depending on the new -ofatal_errors={panic,bug} mount
>> option. Since there are still so many BUG_ONs, it defaults to BUG
>> for now but I expect that to change once the error handling
>> effort has made significant progress.
> 
> Any reason all of the commit text is indented in this series?

Our internal patches have a bunch of RFC822-style headers associated
with them. For me, indenting the body is a style thing. I like having
the body appear separate from the headers.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJOzapOAAoJEB57S2MheeWyiwcQAKEBdb94MUHYxGBWvRcOLrfI
exj387YgPsNuXTRS8FjOW/3q4lIlt4F/35o8AqH8xJZFK4XcCX9/Mmz6HPlK9CfX
uQqtL0rGLW0t3rziArddVJmdab7/5xjG7ZgiVkLNePhZS7mKitLf7MeZh7CAQ3UL
ZyeG2NdkcY5jDkseY+kZbF9UKcpv4aGIetzSbej9GH/bvF6g3QB3d3BNqJ3opp+J
rciqtN2ZKVS5uA82KkXGkjnPcAkQfyfOJgZKKTCc68oMjJZNbPp5Ovcum0XF9mZZ
ZEfOc1kTogsBfB5wR/1lR4Q5HR8JT7YF61ZUceaF6pd420FZmn2HIX6Lphj2pU/a
CR4lrie9Nb/F4Sc+iB1pHyc9r9VhvWb9pQiW1W7hdQl9XoVi2zp5reUEbEsQ7oX6
8SUQHxtm7eceqs8WO+d6XIKCyI3iXBVQ74QSsPjDHH0LvAa7zQcaNuQurvvpoqH3
5p5vTXjUQ2knwJpyccuzNuDKqg5+8kXKHo+tdojT6+8rtLnp7A6N0z7ctvqkaMmR
5L8a+GK15Sd910l1bJbTVagXbolYYCSaYC/ykByXNGEHeOwX2fcCmO4AK/40N4S6
/jdoliJb+Ku19SsSQnDPH1Xb3Mzf+6BDeEUZ9kl2OewtqNxfWpwOkNW/f5iDfBTw
BCncwA37zJPDrhFE5cGg
=A5RF
-----END PGP SIGNATURE-----
