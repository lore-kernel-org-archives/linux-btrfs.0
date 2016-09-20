Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:47597 "EHLO
        frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752098AbcITIsp (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 04:48:45 -0400
Date: Tue, 20 Sep 2016 08:48:38 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Peter Becker <floyd.net@gmail.com>
Cc: Tomasz Chmielewski <mangoo@wpkg.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: how to understand "btrfs fi show" output? "No space left" issues
Message-ID: <20160920084838.GQ7138@carfax.org.uk>
References: <566e9000fe30d5b8e0d7e73ebe1d44a0@admin.virtall.com>
 <20160920065827.GO7138@carfax.org.uk>
 <CAEtw4r16f10PPsVw6r5t0KP-gJbSmKEYP-zt-s5De9kSBpZEqg@mail.gmail.com>
 <6596b749c3c4b37dc1db8c3a766be491@admin.virtall.com>
 <CAEtw4r1NW8Yg9KnGEuUtSe-NYVP-burkB0mDOdKLWsWQ4vy1rw@mail.gmail.com>
 <CAEtw4r1FYDkUxoOW-hrngBX5XD+AydiPY8B1eQv8a=dmA9B8eQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bAr+fMtvBxbbbkvl"
In-Reply-To: <CAEtw4r1FYDkUxoOW-hrngBX5XD+AydiPY8B1eQv8a=dmA9B8eQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--bAr+fMtvBxbbbkvl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 20, 2016 at 10:34:49AM +0200, Peter Becker wrote:
> More details on the issue and a complete explantion you can find here:
> 
> http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
> and
> (Help! I ran out of disk space! )
> https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_I_ran_out_of_disk_space.21
> 
> And an explantion for the "dlimit" solution:

   It's not "dlimit". It's "d" with option "limit". You could just as
easily write -dusage=99,limit=10 or -dlimit=10,usage=99 (although
those aren't the options I'd pick... see below).

> Quote From: Uncommon solutions for BTRFS
> (http://blog.schmorp.de/2015-10-08-smr-archive-drives-fast-now.html)
> 
> > For my purposes, I define internal fragmentation as space allocated but not usable by the filesystem. In BTRFS, each time you delete files, the space used by those files cannot be reused for new files automatically.
> > It's not a hard requirement to do this maintenance regularly, but doing it regularly spares you waiting for hours when the disk is full and you need to wait for a balance clean up command - and of course also reduces the number of > times you get unexpected disk full errors. As a side note, this can also be useful to prolong the life of your SSD because it allows the SSD to reuse space not needed by the filesystem (although there is a trade-off, frequent balancing is bad, no balancing is bad, the sweet spot is somewhere in between).
> 
> 2016-09-20 10:20 GMT+02:00 Peter Becker <floyd.net@gmail.com>:
> > Normaly total and used should deviate us a few gb.
> > depend on your write workload you should run
> >
> > btrfs balance start -dusage=60 /mnt
> >
> > every week to avoid "ENOSPC"
> > 
> > if you use newer btrfs-progs who supper balance limit filters you should run
> >
> > btrfs balance start -dusage=99 -dlimit=10 /mnt
> >
> > every 3 hours.

   These two options both feel horrible to me. Particularly the second
option, which is going to result in huge write load on the FS, and is
almost certainly going to be unnecessary most of the time.

   My recommendation would be to check at regular intervals (daily,
say) whether the used value is equal to the size value in btrfs fi
show. If it is (and only if), then you should run a balance with no
usage= option, and with limit=<n>, for some relatively small value of
<n> (3, say). That will give you some unallocated space that the FS
can take for metadata should it need it, which is all that's required
to avoid early ENOSPC.

   If you regularly find that your usage patterns result in large
numbers of empty or near-empty block groups (i.e. lots of headroom in
data shown by btrfs fi df), then a regular (but probably less
frequent) balance with something like usage=5 should keep that down.

> > This will balance 2 Blocks (dlimit=10; corresponds to 10 gb) with are

   No, it will balance 10 complete block groups, not 10 GiB. Depending
on the RAID configuration, that could be a very large amount of data
indeed. (For example, an 8-disk RAID-10 would be rewriting up to 80
GiB of data with that command).

   Hugo.

> > not filled full into new blocks. You could/should adjust the intervall
> > and the limit-filter depend on your write workload.
> > For example if you write (change files + new files) only 10GB a day it
> > will be enough to run this ever night.
> > The last option completly avoid the ENOSPC issue but produce aditional
> > workload for your harddrives.
> >
> > Note: you should avoid making snapshots during balance. Use a simple
> > lock-mechanic for that.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Hugo Mills             | There isn't a noun that can't be verbed.
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--bAr+fMtvBxbbbkvl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJX4PflAAoJEFheFHXiqx3kTs4QAI2L1dSMf0b+KDujPa+90Rab
uIygE4lK+4giA9CuDpzNHvt4M+eayoPTs2pjTWeCXWs4oQacUc19EfPH+YH+3XMd
/MQv526mMJLgwPct8mpgkjbVH+OIHw3MloVe7rligxfeRWMO1queYcGXoASjtsbl
k7mO5IjohfObu3mdlkc/1HExDlwkT6ZKRlaaXvhSctUVB00zi9A1aLjaeUKPGRwU
Yx9vFDzFCHg0tEeCPlOdSea+OFwPGIcmf229nu/pw060SfWpCKeWg5BCWQsC3v/t
g97WTE4Frlzj+BaTniyyAMBV1tWLtD0t8kjlHKRtLO2Ix7RC0cHCYLK3OX4mZtog
KNQHGBQ95CcYYIviO6didHwmDSDLqQ05oy0CmajPMwu9xgKKyQy1+WYa9txXBmeA
yN8rr3J4bJjcIASR7rVw/DuHojb3Dm9yG8y0Ml0Ufmz1p+mGusTQzYjlspGDg7II
P5Nj0HyuhjJ88Gz5RnCbtXAvP8w0vKuv86VzXyc6nUk0PEJJYyA2j7iD48cvYZ+W
OIscJbLwq5xxgBhKTsq/Z+y7K+NSVUhWhQMlC2W42oxYjqTp2ndxqNOMgfI8sjGs
LGvVvUfeq/SMEvTadIaMAzXHtbLYcp/fybpPxtdB9KkL5HCMy+HsTWtXg5X3YOVM
ZRoTSgMS8fDFfNsXab7d
=CBod
-----END PGP SIGNATURE-----

--bAr+fMtvBxbbbkvl--
