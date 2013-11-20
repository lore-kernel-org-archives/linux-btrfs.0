Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:34949 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444Ab3KTTFl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Nov 2013 14:05:41 -0500
MIME-Version: 1.0
In-Reply-To: <73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>
References: <CAGKKSfWO4qTZsbd-=10cKc7=O7hTCVceMVQvCTJcUh1Z_gW04Q@mail.gmail.com>
	<528A90B7.5010905@zytor.com>
	<CAGKKSfWXv4vzVDz-wOm=wC=oU3uM3t7hnp39CoXFkOjyjN_knA@mail.gmail.com>
	<528AA1EB.3010909@zytor.com>
	<CAGKKSfVEMuRYf-L5Nfy0Q4SHKcks0VhPJkj73vy+krsNhSkruA@mail.gmail.com>
	<528BCA2D.5010500@redhat.com>
	<73BEB41F-0FAC-4108-BEA9-DB6D921F6F55@cs.utk.edu>
Date: Wed, 20 Nov 2013 20:05:40 +0100
Message-ID: <CAGKKSfUGLzeLfab0uJTGV=UELxEH+mB3K4VbDouHxzmc+xuZ2A@mail.gmail.com>
Subject: Re: Triple parity and beyond
From: Andrea Mazzoleni <amadvance@gmail.com>
To: James Plank <plank@cs.utk.edu>
Cc: Ric Wheeler <rwheeler@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        David Brown <david.brown@hesbynett.no>,
        David Smith <creamyfish@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jim,

I build the matrix in a way that results in coefficients matching
Linux RAID for the first two rows, and at the same time gives
the guarantee that all the square submatrices are not singular,
resulting in a MDS code.

I start forming a Cauchy matrix setting each element to 1/(xi+yj)
where all xi and yj are distinct elements. This is how a Cauchy
matrix is usually defined in textbooks.

For the first row with j=0, I use xi = 2^-i and y0 = 0, that results in:

row j=0 -> 1/(xi+y0) = 1/(2^-i + 0) = 2^i (RAID-6 coefficients)

For the next rows with j>0, I use yj = 2^j, resulting in:

rows j>0 -> 1/(xi+yj) = 1/(2^-i + 2^j)

with xi != yj for any i,j with i>=0,j>=1,i+j<255

Then I put at the top of the Cauchy matrix a row filled with 1,
transforming it in an Extended Cauchy Matrix.
This transformation maintains the property of having all the
square submatrices not singular.
I found this property mentioned in some papers/textbooks, like
in the introduction of:

Vinocha, On Generator Cauchy Matrices of GDRS/GTRS Codes, 2012
http://www.m-hikari.com/ijcms/ijcms-2012/45-48-2012/brarIJCMS45-48-2012.pdf

Finally I adjust all the rows to have the first column filled with 1,
with a multiplication of each row for an adjusting factor.
Also this transformation maintains the property of having all the
square submatrices not singular, and then we have a MDS code.

Ciao,
Andrea
