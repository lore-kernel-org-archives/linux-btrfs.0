Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tulsa-1.icequake.net ([65.38.17.15]:48547 "EHLO
	mail.icequake.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768347Ab2KOQJk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Nov 2012 11:09:40 -0500
Received: from localhost (aurora [127.0.0.1])
	by mail.icequake.net (Postfix) with ESMTP id DBDB8FFF0
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2012 10:00:27 -0600 (CST)
Received: from mail.icequake.net ([127.0.0.1])
	by localhost (aurora.icequake.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZVB-XZKRoZXT for <linux-btrfs@vger.kernel.org>;
	Thu, 15 Nov 2012 10:00:21 -0600 (CST)
Received: from localhost (m9a2636d0.tmodns.net [208.54.38.154])
	by mail.icequake.net (Postfix) with ESMTPSA id F3F4BFFCE
	for <linux-btrfs@vger.kernel.org>; Thu, 15 Nov 2012 10:00:10 -0600 (CST)
Date: Thu, 15 Nov 2012 10:00:03 -0600
From: "Ryan C. Underwood" <nemesis-lists@icequake.net>
To: linux-btrfs@vger.kernel.org
Subject: Re: Several unhappy btrfs's after RAID meltdown
Message-ID: <20121115160003.GA32396@localhost.localdomain>
Reply-To: nemesis@icequake.net
References: <20120205184128.GC18806@localhost.localdomain>
 <20120207033945.GA5639@localhost.localdomain>
 <pan.2012.02.07.09.53.58@cox.net>
 <20120207140431.GB5639@localhost.localdomain>
 <CAKcLGm9mLhwc1ZFp=ingR814X77QetX3LOkSqxdbussjj2gykQ@mail.gmail.com>
 <20120207154225.GD5639@localhost.localdomain>
 <20120207174645.GE5639@localhost.localdomain>
 <20120207174907.GF5639@localhost.localdomain>
 <20120212163134.GA15216@localhost.localdomain>
 <20120601143857.GB25227@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXfL5xGRrasGEqWY"
In-Reply-To: <20120601143857.GB25227@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Finally made some more progress on one of my melted down btrfs from
earlier this year.

First I hacked find-root.c to not stop scanning the disk when it
thinks it has found the real root.  I wanted it to print out all
possible roots.  I saved the stderr output to a logfile.  About 1226
possible roots were found.

Then I used btrfs-restore, iterating over each one of these to
attempt to use each one of them as the root and see what files could
be found:

for temp in `sed 's/^.*block \([0-9]\+\).*$/\1/' log`;
    do echo $temp;
    nice ./btrfs-restore -t $temp /dev/mapper/tr5ut-vicep--library /mnt/rec=
overy;
done

In this way I was able to recover about 36GB of data and the
directory structure of what is recovered looks fine.  The data also
looks fine too by scanning MIME types with "file" and selecting a few
text or HTML files to check manually.

There is still a lot of data missing though.  If I am reading this
correctly there was about 300GB of data which compressed to 254GB
on-disk.

Label: 'vicep-library'  uuid: 89b14d35-b31a-4fbe-a2d9-cb83cbcd3851
        Total devices 1 FS bytes used 254.35GB
        devid    1 size 1.00TB used 299.04GB path /dev/dm-27

A lot of my btrfs-restore output looks like this:

318259351552
parent transid verify failed on 318259351552 wanted 575931 found 546662
parent transid verify failed on 318259351552 wanted 575931 found 546662
parent transid verify failed on 318259351552 wanted 575931 found 546662
parent transid verify failed on 318259351552 wanted 575931 found 546662
Ignoring transid failure
parent transid verify failed on 318125375488 wanted 541528 found 572360
parent transid verify failed on 318125375488 wanted 541528 found 572360
parent transid verify failed on 318125375488 wanted 541528 found 572360
parent transid verify failed on 318125375488 wanted 541528 found 572360
Ignoring transid failure
parent transid verify failed on 561016832 wanted 544038 found 574369
parent transid verify failed on 561016832 wanted 544038 found 574369
parent transid verify failed on 561016832 wanted 544038 found 574369
parent transid verify failed on 561016832 wanted 544038 found 574369
Ignoring transid failure
leaf parent key incorrect 561016832
Root objectid is 5
parent transid verify failed on 164073472 wanted 544650 found 562972
parent transid verify failed on 164073472 wanted 544650 found 562972
parent transid verify failed on 164073472 wanted 544650 found 562972
parent transid verify failed on 164073472 wanted 544650 found 562972
Ignoring transid failure
leaf parent key incorrect 164073472
Error searching -1

As far as I can see only the #5 root object was found, at least I
don't see any others found in the output.  This could account for the
missing data.  How could I get to the other root objects?

--=20
Ryan C. Underwood, <nemesis@icequake.net>

--OXfL5xGRrasGEqWY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFQpRGDIonHnh+67jkRAgoIAJ4hkbpS3UXGLqDQVqDVHc/BEEAjwQCeP7k+
RYtV6zSj9rvvje46UJsHf94=
=iTwQ
-----END PGP SIGNATURE-----

--OXfL5xGRrasGEqWY--
