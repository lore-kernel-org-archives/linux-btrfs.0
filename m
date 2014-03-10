Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:9042 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753157AbaCJPvF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Mar 2014 11:51:05 -0400
Message-ID: <531DDF4E.3090600@fb.com>
Date: Mon, 10 Mar 2014 11:50:38 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Shilong Wang <wangshilong1991@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Subject: Re: [PATCH] Btrfs-progs: fsck: disable --init-extent-tree option
 when using snapshots
References: <1394447961-27981-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <CAP9B-Qm8p5zPBDpvEwwOHGUxpRqHkBCsNGk21+8qaoYkhx44zA@mail.gmail.com>
In-Reply-To: <CAP9B-Qm8p5zPBDpvEwwOHGUxpRqHkBCsNGk21+8qaoYkhx44zA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/10/2014 08:12 AM, Shilong Wang wrote:
> Hi Josef,
> 
> As i haven't thought any better ideas to rebuild extent tree which
> contains extent that owns 'FULL BACKREF' flag.
> 
> Considering an extent's refs can be equal or more than 1 if this
> extent has *FULL BACKREF* flag, so we could not make sure an
> extent's flag by only searching fs/file tree any more.
> 
> So until now, i just disable this option if snapshots exists,
> please correct me if i miss something here. Or you have any better
> ideas to solve this problem.~_~
> 
> 

I thought the fsck stuff rebuilds full backref refs properly, does it
not?  If it doesn't we need to fix that, however I'm fine with
disabling the option if snapshots exist for the time being.  Thanks,

Josef
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJTHd9NAAoJEANb+wAKly3BYCYP/0iTaaa7w0SnfXtgjoVyX+nT
+e0Pa46zeKzpTujotCDb9E/2PBesCAvA4Psog3rkfsqJ2nXN9cERN4E6/JG4nAHh
Hv4KPo+w+tCkC4U2wSoDivYrVk9G5SH25ewkgW6iheSYNIlm+PLbOQz9DzGjCFDp
51J9tG5E010siOyhlLCyGj8ZTj+gXuoQVWKCS8dOpCLMrbYYjMDXa562hqWaLoS/
t3eSfP7Tnnpl43NiMZI4fWrzmlFa5lba5iJmG59FeyiseRH4Zrhee4St1L1xDL5A
/6f3tJJT7DJjRRJFv0nJAOvOPyFaK8bMaYmOQJg6VrhcyPKM3BxBVEab3HrmQ7jt
LCMWobpIcM7e5BugmbTGGsFymhv05SQgvYGzpzRVXdsSzqubuqTcXwloNU5RyyFF
sXT9IiW9wAibHe7mDN7V6nfo1bVfHsjvSVi1rqz4/zFOWyh8oqxfEhxUJIWhfFsn
j0WJevvqKnjBJujyyuQpL13tzh69qei0AHOEme3R46BSRMnyuacy/WOeyo4VXPcn
0GIeWbngAIWF/quhoQGkvofRMlPgftiDge8uz9pbm3IEKeiP9dQ/HvKsIHMKjnKW
3dEBvMV/CSUQNek4VjO1ALefTRZQvJVL8Wxdij4W+djJw/uVX7fOhuqdkqyfM3FY
CKSB3HUSUtDCammsvgQA
=OT98
-----END PGP SIGNATURE-----
