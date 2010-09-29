From: Francis Galiegue <fgaliegue@gmail.com>
Subject: Re: Another checksum error bugreport
Date: Wed, 29 Sep 2010 14:50:36 +0200
Message-ID: <AANLkTimAk-svytPk-rQFXAZkrKdT5pU35GYfV7W33hi0@mail.gmail.com>
References: <AANLkTi=vHyE+epYixXgu5ju_JfjWdU+xghL-PLo60ktu@mail.gmail.com>
	<AANLkTinqsjRZ8uGpz_xmVHCLLaqC1rO_uE=KFcfMMaW0@mail.gmail.com>
	<AANLkTi=UNd1=_q+n6m0vmf_YvDP1PBWZftCF=dUnNTYx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Sebastian 'gonX' Jensen" <gonx@overclocked.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=UNd1=_q+n6m0vmf_YvDP1PBWZftCF=dUnNTYx@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 29, 2010 at 13:37, Sebastian 'gonX' Jensen
<gonx@overclocked.net> wrote:
[...]
>>
>> Which kernel is that?
> It was one of the 2.6.35 versions from the Ubuntu repository. I'm
> running Ubuntu 10.04 Server.
>

Since 2.6.32 works, you should report that bug to Ubuntu.

The upstream commit is f281fb5fe54e15a7ab802945e42f8e24fceb56b2,
pasted below, merged Sep 25:

----
commit f281fb5fe54e15a7ab802945e42f8e24fceb56b2
Author: Adrian Hunter <adrian.hunter@nokia.com>
Date:   Sat Sep 25 12:42:55 2010 +0200

    block: prevent merges of discard and write requests

    Add logic to prevent two I/O requests being merged if
    only one of them is a discard.  Ditto secure discard.

    Without this fix, it is possible for write requests
    to transform into discard requests.  For example:

      Submit bio 1 to discard 8 sectors from sector n
      Submit bio 2 to write 8 sectors from sector n + 16
      Submit bio 3 to write 8 sectors from sector n + 8

    Bio 1 becomes request 1.  Bio 2 becomes request 2.
    Bio 3 is merged with request 2, and then subsequently
    request 2 is merged with request 1 resulting in just
    one I/O request which discards all 24 sectors.

    Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>

    (Moved the checks above the position checks /Jens)

    Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
----

--=20
=46rancis Galiegue, fgaliegue@gmail.com
"It seems obvious [...] that at least some 'business intelligence'
tools invest so much intelligence on the business side that they have
nothing left for generating SQL queries" (St=C3=A9phane Faroult, in "Th=
e
Art of SQL", ISBN 0-596-00894-5)
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
