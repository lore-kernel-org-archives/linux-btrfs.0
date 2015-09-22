Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:45592 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933680AbbIVUEj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Sep 2015 16:04:39 -0400
Date: Tue, 22 Sep 2015 20:04:35 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: carlo von lynX <lynX@time.to.get.psyced.org>
Cc: linux-btrfs@vger.kernel.org, fdmanana@suse.com
Subject: Re: btrfs receive bigger than original snapshot?
Message-ID: <20150922200435.GL5918@carfax.org.uk>
References: <20150922195219.GA23903@lo.psyced.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2EnvhqpWJq810sZn"
In-Reply-To: <20150922195219.GA23903@lo.psyced.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--2EnvhqpWJq810sZn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 22, 2015 at 09:52:19PM +0200, carlo von lynX wrote:
> Hello, it's me again. This time I searched the web to make sure
> I'm not making another beginner's mistake. I'm still not on the
> list, so please keep me in cc: on replies.
> 
> I have optimized a btrfs subvolume with a script* that reflinks
> all files with identical contents, then I did a read-only snap
> and fed it to send/receive. The bad news: on the receiving
> side the same snapshot grew from 5.5G to 7.1G.

   That's something I'd definitely expect it to be able to do. If it's
not doing it, I'd say there's something wrong. cc'ing Filipe, who is,
I think, currently the local expert on send/receive.

> I assume send/receive does not support one of the coolest
> btrfs features ever.. reflinks. Didn't find any mention on this
> on https://btrfs.wiki.kernel.org/index.php/Incremental_Backup
> or other pages. Is there any documentation that would explain
> to me why this has to be or is it just a missing feature that
> someone someday may find the time to add?
> 
> Generally I find it odd that btrfs receive would not recreate
> an identical clone of the original snapshot, that would also
> allow me to continue working on a backup hard disk, then merge
> the changes back to the main disk. Instead I have to decide
> which device contains the master copy for all times and never
> make rw snapshots elsewhere. What if the master disk dies?
> Then I can turn a backup into the new master but I will have
> to re-bootstrap all other backups as they will not accept the
> non-identical parent snapshot.

   That's a known drawback, and one that's been discussed on this list
already. It's fixable (within some limits), but requires a change to
the send stream format. (See my analysis below).

> Apparently I'm not the only one that thought this to be a
> defect rather than a design choice:
>     http://www.spinics.net/lists/linux-btrfs/msg45175.html
> 
> This actually confused me (in particular the absence of responses
> to that mail), that's why I have btrfs-progs 4.0 installed...
> but in the meantime I figured out that I expected send/receive
> to be bidirectional. So my question in this case.. is there a
> higher reasoning for the inexactness of send/receive transfers?

   It's about tracking enough metadata to be sure that the send (or
the receive) is actually feasible. See
http://www.spinics.net/lists/linux-btrfs/msg44089.html for my analysis
of the problem, and (theoretical) suggestions for what the solution
should look like.

> And another classic: since the output size of the snapshot copy
> is unpredictable, running out of disk space can be frequent.
> Wouldn't it be cool if receive could resume rather than restarting
> from scratch?

   Resuming is a bit tricky -- how do you know where to resume from?
Bear in mind that send simply writes its results to stdout, so it has
no knowledge of anything on the receiving side. In fact, the receiving
side may not even exist at the point that the send stream is created.

   Hugo.

> But maybe I still got it all wrong in my head. If these things
> are FAQs, please add them to the FAQ document. In particular some
> criteria to decide when rsync is actually a more suitable tool
> over send/receive, which apparently under some circumstances is
> the case. In some other cases, git can be the better suited tool.
> 
> Still I am very glad that you created a new alternative for data
> organization between the extremes of reckless rsync and overly
> accurate git. It's just a steep learning mountain.
> 
> 
> *) I used fdupes' output ran through a perl script that calls
>   "cp --reflink" for each match. Would "bedup" or "duperemove"
>  do a better job? bedup looks like a better long-term solution.
> 
> 

-- 
Hugo Mills             | Great oxymorons of the world, no. 3:
hugo@... carfax.org.uk | Military Intelligence
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--2EnvhqpWJq810sZn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIbBAEBAgAGBQJWAbRTAAoJEFheFHXiqx3kLiwP93NUEC9mLW6Ati6gSRQJ3wTd
YJ4s3rtPsMsRqxoyd8uGj2g/vSxd8FZlKOvWsb0LH5EyTPxF+9RUdgsJKp8AHbVK
795OP653V76YIgm9yK/a1sT3nUv136vXjZRAfbWnTZGkXAdqpMOuBmOZ+Ct0I5Ie
zPYsUDWEalvdbbMEqpYH9J78J9CWzu8fvwpwvbMiz9RVuKTMsS4HsAhNGF3xsuYz
5xmGqp4YNV38+uIbOzaZ0tHj7okQuad6ggjW8jZ2yGZSxOqCIx53j0QmaTmOAh1w
khcLNhKqCwLqT01hGs106hxrQA7qLwe6KO8hy9pOJ57oITG4LzqFgc0dk2mgRGcw
XIHANn3Ff6RzTdugK/j7cLyC2Njwt+aJs7JOn36yomH5KxiPQ4AEYlc4qFvuTz+9
vtBHx9yWmm1GXYMY5AkbzjHyjO0pPwKtHvu3KlZWNW826dmKLHqFKcOi5ZM078Ac
ZoYB8/jcTdcv0A29KxGxqIbE3KsMzFXDjiph5YBxnLOCLWEKrQBAHdBREESmSyjy
KCMwt5N/nNoYYX+rOW89CDR1oPUJ+HfmRo3To1ynXdsuL/ZU3jKOVrthsHmOz6nY
wsiDGwbaC60ddQRBa6UM5qEeYLTKVlTwXvCdmE30B/2SaXYlmenDkdyaQPx/6V9A
upkSIR5cGJJwgQyRi+A=
=t8bl
-----END PGP SIGNATURE-----

--2EnvhqpWJq810sZn--
