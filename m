Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51116 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754077AbaCNNgL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Mar 2014 09:36:11 -0400
Received: by mail-pa0-f54.google.com with SMTP id lf10so2664222pab.27
        for <linux-btrfs@vger.kernel.org>; Fri, 14 Mar 2014 06:36:11 -0700 (PDT)
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] Btrfs-progs: fsck: disable --init-extent-tree option when using snapshots
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <531E657A.2000803@cn.fujitsu.com>
Date: Fri, 14 Mar 2014 21:36:14 +0800
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <9BB6AEEF-1B52-449E-BB89-B3619EE968EB@gmail.com>
References: <1394447961-27981-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <CAP9B-Qm8p5zPBDpvEwwOHGUxpRqHkBCsNGk21+8qaoYkhx44zA@mail.gmail.com> <531DDF4E.3090600@fb.com> <531E657A.2000803@cn.fujitsu.com>
To: Josef Bacik <jbacik@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Josef,

Just ping this again.

Did you have any good ideas to rebuild extent tree if broken filesystem
is filled with snapshots.?

I was working on this recently, i was blocked that i can not verify if an extent
is *FULL BACKREF* mode or not. As a *FULL BACKREF* extent's refs can be 1
and more than 1..

I am willing to test  codes or have a try if you could give me some advice etc.

-Wang

> On 03/10/2014 11:50 PM, Josef Bacik wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>> 
>> On 03/10/2014 08:12 AM, Shilong Wang wrote:
>>> Hi Josef,
>>> 
>>> As i haven't thought any better ideas to rebuild extent tree which
>>> contains extent that owns 'FULL BACKREF' flag.
>>> 
>>> Considering an extent's refs can be equal or more than 1 if this
>>> extent has *FULL BACKREF* flag, so we could not make sure an
>>> extent's flag by only searching fs/file tree any more.
>>> 
>>> So until now, i just disable this option if snapshots exists,
>>> please correct me if i miss something here. Or you have any better
>>> ideas to solve this problem.~_~
>>> 
>>> 
>> I thought the fsck stuff rebuilds full backref refs properly, does it
>> not?  If it doesn't we need to fix that, however I'm fine with
>> disabling the option if snapshots exist for the time being.  Thanks,
> If there are no snapshots, --init-extent-tree can works as expected.
> I just have not thought a better idea to rebuild extent tree if we do have
> snapshots which means we may have an extent with *FULL BACKREF*
> flag.
> 
> Thanks,
> Wang
>> 
>> Josef
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG v1
>> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
>> 
>> iQIcBAEBAgAGBQJTHd9NAAoJEANb+wAKly3BYCYP/0iTaaa7w0SnfXtgjoVyX+nT
>> +e0Pa46zeKzpTujotCDb9E/2PBesCAvA4Psog3rkfsqJ2nXN9cERN4E6/JG4nAHh
>> Hv4KPo+w+tCkC4U2wSoDivYrVk9G5SH25ewkgW6iheSYNIlm+PLbOQz9DzGjCFDp
>> 51J9tG5E010siOyhlLCyGj8ZTj+gXuoQVWKCS8dOpCLMrbYYjMDXa562hqWaLoS/
>> t3eSfP7Tnnpl43NiMZI4fWrzmlFa5lba5iJmG59FeyiseRH4Zrhee4St1L1xDL5A
>> /6f3tJJT7DJjRRJFv0nJAOvOPyFaK8bMaYmOQJg6VrhcyPKM3BxBVEab3HrmQ7jt
>> LCMWobpIcM7e5BugmbTGGsFymhv05SQgvYGzpzRVXdsSzqubuqTcXwloNU5RyyFF
>> sXT9IiW9wAibHe7mDN7V6nfo1bVfHsjvSVi1rqz4/zFOWyh8oqxfEhxUJIWhfFsn
>> j0WJevvqKnjBJujyyuQpL13tzh69qei0AHOEme3R46BSRMnyuacy/WOeyo4VXPcn
>> 0GIeWbngAIWF/quhoQGkvofRMlPgftiDge8uz9pbm3IEKeiP9dQ/HvKsIHMKjnKW
>> 3dEBvMV/CSUQNek4VjO1ALefTRZQvJVL8Wxdij4W+djJw/uVX7fOhuqdkqyfM3FY
>> CKSB3HUSUtDCammsvgQA
>> =OT98
>> -----END PGP SIGNATURE-----
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
> 

